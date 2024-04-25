//
//  FilterView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 25/04/2024.
//

import SwiftUI

struct FilterView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersMainViewModel
    
    var body: some View {
        VStack {
            Text("Filter")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
                .padding(.leading, 10)
            
            HStack {
                Button(action: {
                    mainViewModel.sortBy(filter: .alphabetical)
                }, label: {
                    ButtonLabel(title: "Alphabetical",
                                imageName: "a.square",
                                color: mainViewModel.characters.isEmpty ? .gray : .teal)
                })
                .disabled(mainViewModel.characters.isEmpty)
                
                Button(action: {
                    mainViewModel.sortBy(filter: .popularity)
                }, label: {
                    ButtonLabel(title: "Popularity",
                                imageName: "person.3.fill",
                                color: mainViewModel.characters.isEmpty ? .gray : .indigo)
                })
                .disabled(mainViewModel.characters.isEmpty)
            }
        }
    }
}

struct ButtonLabel: View {
    
    let title: String
    let imageName: String
    let color: Color
    
    var body: some View {
        
        Label(title, systemImage: imageName)
            .frame(width: 150, height: 40)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding()
    }
}

#Preview {
    FilterView()
        .environmentObject(DisneyCharactersMainViewModel())
}
