//
//  CharacterRowView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    
    var body: some View {
        HStack {
            if let imageUrl = character.imageUrl {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 60, maxHeight: 60)
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.black, lineWidth: 2))
                    case .failure:
                        Image(systemName: "person.fill.questionmark")
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 60, maxHeight: 60)
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.black, lineWidth: 2))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.fill.questionmark")
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 60, maxHeight: 60)
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.black, lineWidth: 2))
            }
            
            
            Text(character.name)
                .font(.headline)
                .padding(.leading, 10)
            Spacer()
        }
        
    }
}

#Preview {
    CharacterRowView(character: Character.example)
}
