//
//  FavouriteView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct FavouriteView: View {
    
    private struct Constants {
        static var maxHeigth: CGFloat = 100
        
    }
    @EnvironmentObject var mainViewModel: DisneyCharactersViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Favourites")
                .font(.headline)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(mainViewModel.favouriteCharacters, id: \._id) { character in
                        NavigationLink {
                            CharacterDetailView(character: character)
                        } label: {
                            RemoteImage(url: character.imageUrl, size: CGSize(width: 30, height: 30))
                        }
                    }
                }
            }
            .scrollClipDisabled()
        }
        .frame(height: Constants.maxHeigth)
        .padding(.horizontal)
    }
}

#Preview {
    FavouriteView()
        .environmentObject(DisneyCharactersViewModel())
}
