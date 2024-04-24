//
//  CharacterDetailView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersMainViewModel
    @StateObject private var viewModel = DetailViewModel()
    
    let character: Character
   
    var body: some View {
        VStack {
            RemoteImage(url: character.imageUrl, size: CGSize(width: 150, height: 150))
            
            HStack {
                Text(character.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button(action: {
                    if mainViewModel.isFavourite(character) {
                        mainViewModel.removeFromFavourite(character)
                    } else {
                        mainViewModel.addToFavourite(character)
                    }
                    
                }, label: {
                    if mainViewModel.isFavourite(character) {
                        Image(systemName: "star.fill")
                            .renderingMode(.original)
                            
                    } else {
                        Image(systemName: "star")
                            .renderingMode(.original)
                    }
                    
                        
                })
            }

            List {
                if character.films.count > 0 {
                    Section("Films", isExpanded: $viewModel.isFilmSectionExpanded) {
                        ForEach(character.films, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if character.shortFilms.count > 0 {
                    Section("Short films", isExpanded: $viewModel.isShortFilmSectionExpanded) {
                        ForEach(character.shortFilms, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if character.tvShows.count > 0 {
                    Section("TV shows", isExpanded: $viewModel.isTVShowsSectionExpanded) {
                        ForEach(character.tvShows, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if character.videoGames.count > 0 {
                    Section("Videogames", isExpanded: $viewModel.isTVShowsSectionExpanded) {
                        ForEach(character.videoGames, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if character.parkAttractions.count > 0 {
                    Section("Park attractions", isExpanded: $viewModel.isParkAttractionSectionExpanded) {
                        ForEach(character.parkAttractions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if character.allies.count > 0 {
                    Section("Allies", isExpanded: $viewModel.isAlliesSectionExpanded) {
                        ForEach(character.allies, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if character.enemies.count > 0 {
                    Section("Enemies", isExpanded: $viewModel.isEnemiesSectionExpanded) {
                        ForEach(character.enemies, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                if let fandomURL = URL(string: character.sourceUrl) {
                    Section("External links") {
                        NavigationLink {
                            WebView(url: fandomURL)
                        } label: {
                            Text("Fandom page")
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}

#Preview {
    CharacterDetailView(character: Character.example)
        .environmentObject(DisneyCharactersMainViewModel())
}
