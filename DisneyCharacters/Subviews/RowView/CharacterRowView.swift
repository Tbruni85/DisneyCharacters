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
            RemoteImage(url: character.imageUrl)
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
