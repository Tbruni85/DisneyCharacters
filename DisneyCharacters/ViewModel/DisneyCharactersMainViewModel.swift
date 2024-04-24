//
//  DisneyCharactersMainViewModel.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation

class DisneyCharactersMainViewModel: ObservableObject {
    
    private struct Constants {
        static var pageSize = 50
    }
    
    @Published var characters: [Character] = []
    @Published var favouriteCharacters: [Character] = []
    @Published var filterType: FilterType = .alphabetical
    var mainViewDidLoad = false
    private var currentPage = 1
    
    private let savePath = URL.documentsDirectory.appending(path: "FavouriteCharacters")
    private let interactor: InteractorProviding
    
    enum FilterType: String, CaseIterable {
        case alphabetical
        case popularity
    }
    
    init(interactor: InteractorProviding = Interactor()) {
        self.interactor = interactor
    }
    
    @MainActor
    func getListOfCharacters() async throws {
        
        do {
            let response: CharacterList = try await interactor.getListOfCharacters(page: currentPage, pageSize: Constants.pageSize)
            if Task.isCancelled { return }
            characters.append(contentsOf: response.data)
            sortBy(filter: filterType)
        }
        catch {
            if Task.isCancelled {
                print(error.localizedDescription)
                currentPage -= 1
                return
            }
        }
    }
    
    func sortBy(filter: FilterType) {
        switch filter {
        case .alphabetical:
            characters.sort {
                $0.name < $1.name
            }
        case .popularity:
            characters.sort {
                if  $0.films.count == $1.films.count {
                    return $0.shortFilms.count > $1.shortFilms.count
                }
                return $0.films.count > $1.films.count
            }
        }
    }
}

// MARK: Pagination Logic
extension DisneyCharactersMainViewModel {
    
    @MainActor
    func requestMoreCharacters(_ element: Character) async {
        if element._id == characters[characters.count - 20]._id {
            currentPage += 1
            do {
                try await getListOfCharacters()
                if Task.isCancelled { return }
            }
            catch {
                print(error.localizedDescription)
                if Task.isCancelled { return }
            }
        }
    }
}

// MARK: Favourite logic handler
extension DisneyCharactersMainViewModel {
    
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
}

// MARK: Save / Load functions
extension DisneyCharactersMainViewModel {
    
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
