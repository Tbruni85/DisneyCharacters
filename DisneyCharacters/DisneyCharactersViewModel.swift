//
//  DisneyCharactersViewModel.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation


class DisneyCharactersViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    private let interactor: InteractorProviding
    
    init(interactor: InteractorProviding = Interactor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getListOfCharacters(page: Int, pageSize: Int = 60) async throws {
        
        do {
            let response: CharacterList = try await interactor.getListOfCharacters(page: page, pageSize: pageSize)
            characters = response.data.sorted(by: {
                $0.name < $1.name
            })
        }
        catch {
            print(error)
        }
    }
}
