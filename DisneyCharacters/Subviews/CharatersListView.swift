//
//  CharacterListView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 17/05/2024.
//

import SwiftUI

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

#Preview {
    CharatersListView()
        .environmentObject(DisneyCharactersMainViewModel())
}
