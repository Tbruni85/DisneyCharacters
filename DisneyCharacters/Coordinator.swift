//
//  Coordinator.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 03/05/2024.
//

import Foundation
import SwiftUI


class Coordinator {
    
    enum Routes {
        case detailView(character: Character)
        
        var view: some View {
            switch self {
            case .detailView(let character):
                return CharacterDetailView(character: character)
            }
        }
    }
    
    func goTo(route: Routes) -> some View {
        return route.view
    }
}
