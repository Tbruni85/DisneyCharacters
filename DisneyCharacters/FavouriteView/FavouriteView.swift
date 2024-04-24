//
//  FavouriteView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct FavouriteView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(mainViewModel.favouriteCharacters, id: \._id) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        RemoteImage(url: character.imageUrl ?? "")
                    }
                }
            }
        }
    }
}

#Preview {
    FavouriteView()
        .environmentObject(DisneyCharactersViewModel())
}
