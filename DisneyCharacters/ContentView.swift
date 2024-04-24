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
                Text("Filter")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                    .padding(.leading, 10)
                        
                Picker("Character filter", selection: $mainViewModel.filterType) {
                    ForEach(DisneyCharactersMainViewModel.FilterType.allCases, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: mainViewModel.filterType) {
                    mainViewModel.sortBy(filter: $1)
                }
                
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
                .navigationDestination(for: Character.self) { item in
                    CharacterDetailView(character: item)
                }
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
            .navigationTitle("Disney characters")
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(DisneyCharactersMainViewModel())
}
