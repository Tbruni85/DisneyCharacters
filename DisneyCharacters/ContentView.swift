//
//  ContentView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersMainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if mainViewModel.favouriteCharacters.count > 0 {
                    FavouriteView()
                }
                
                FilterView()
                if mainViewModel.characters.isEmpty {
                    ContentUnavailableView(label: {
                        VStack {
                            ProgressView()
                        }
                    }, description: {
                        Text("Fetching Disney characters")
                    })
                    
                } else {
                    List {
                        Section("Characters") {
                            ForEach(mainViewModel.characters, id:\._id) { character in
                                NavigationLink(value: character) {
                                    CharacterRowView(character: character)
                                        .task {
                                            await mainViewModel.requestMoreCharacters(character)
                                        }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    if mainViewModel.isFavourite(character) {
                                        Button("Remove from Favourites") {
                                            mainViewModel.removeFromFavourite(character)
                                        }
                                        .tint(.red)
                                    } else {
                                        Button("Add to Favourites") {
                                            mainViewModel.addToFavourite(character)
                                        }
                                        .tint(.yellow)
                                    }
                                }
                            }
                            
                        }
                    }
                    .listStyle(.inset)
                    .scrollIndicators(.hidden)
                    .navigationDestination(for: Character.self) { item in
                        mainViewModel.goTo(route: .detailView(character: item))
                    }
                }
            }
            .navigationTitle("Disney characters")
            .task {
                if !mainViewModel.mainViewDidLoad {
                    mainViewModel.loadSaveData()
                    do {
                        try await mainViewModel.getListOfCharacters()
                    }
                    catch {
                        print(error)
                    }
                    mainViewModel.mainViewDidLoad = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DisneyCharactersMainViewModel())
}
