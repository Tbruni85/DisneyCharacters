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
                if mainViewModel.hasFavourites {
                    FavouriteView()
                }
                
                FilterView()
                switch mainViewModel.viewState {
                case .hasCharacters:
                    CharatersListView()
                case .noData:
                    ContentUnavailableView(label: {
                        VStack {
                            ProgressView()
                        }
                    }, description: {
                        Text("Fetching Disney characters")
                    })
                case .errorData:
                    ContentUnavailableView(label: {
                        VStack {
                            Text("Message")
                        }
                    }, description: {
                        Text("Something went wrong fetching data")
                    })
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


struct CharatersListView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersMainViewModel
    
    var body: some View {
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
            CharacterDetailView(character: item)
        }
    }
}
