//
//  ContentView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = DisneyCharactersViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.characters, id:\._id) {
                        CharacterRowView(character: $0)
                    }
                }
                .listStyle(.inset)
                .task {
                    do {
                        try await viewModel.getListOfCharacters(page: 1)
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
}
