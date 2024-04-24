//
//  DisneyCharactersViewModel.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation

class DisneyCharactersViewModel: ObservableObject {
    
    private struct Constants {
        static var pageSize = 60
    }
    
    @Published var characters: [Character] = []
    @Published var favouriteCharacters: [Character] = []
    private var currentPage = 1
    
    private let savePath = URL.documentsDirectory.appending(path: "FavouriteCharacters")
    private let interactor: InteractorProviding
    
    init(interactor: InteractorProviding = Interactor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getListOfCharacters() async throws {
        do {
            let response: CharacterList = try await interactor.getListOfCharacters(page: currentPage, pageSize: Constants.pageSize)
            characters = response.data
        }
        catch {
            print(error)
            characters = []
        }
    }
    
    func isFavourite(_ character: Character) -> Bool {
        favouriteCharacters.contains {
            $0 == character
        }
    }
    
    func addToFavourite(_ character: Character) {
        favouriteCharacters.append(character)
        save()
    }
    
    func removeFromFavourite(_ character: Character) {
        guard let index = favouriteCharacters.firstIndex(of:character) else {
            return
        }
        favouriteCharacters.remove(at: index)
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(favouriteCharacters)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadSaveData() {
        do {
            let data = try Data(contentsOf: savePath)
            favouriteCharacters = try JSONDecoder().decode([Character].self, from: data)
        } catch {
            print("Error reading file: \(error)")
        }
    }
}
