//
//  ContentView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if mainViewModel.favouriteCharacters.count > 0 {
                        Section("Favourites") {
                            FavouriteView()
                        }
                    }
                    
                    Section("Characters") {
                        ForEach(mainViewModel.characters, id:\._id) { character in
                            NavigationLink(value: character) {
                                CharacterRowView(character: character)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
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
                    
                    mainViewModel.loadSaveData()
                    do {
                        try await mainViewModel.getListOfCharacters()
                    }
                    catch {
                        print(error)
                    }
                    
                }
            }
            .navigationTitle("Disney characters")
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(DisneyCharactersViewModel())
}
