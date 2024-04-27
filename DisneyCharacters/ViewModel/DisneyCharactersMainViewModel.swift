//
//  DisneyCharactersMainViewModel.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation

class DisneyCharactersMainViewModel: ObservableObject {
    
    internal struct Constants {
        static var pageSize = 50
        static var pageThreshold = 10
    }
    
    @Published var characters: [Character] = []
    @Published var favouriteCharacters: [Character] = []
    var mainViewDidLoad = false
    
    internal var currentPage = 1
    internal let savePath = URL.documentsDirectory.appending(path: "FavouriteCharacters")
    private let interactor: InteractorProviding
    
    enum FilterType: String, CaseIterable {
        case alphabetical
        case popularity
    }
    
    init(interactor: InteractorProviding = Interactor()) {
        self.interactor = interactor
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

// MARK: Fetch data
extension DisneyCharactersMainViewModel {
    
    func getListOfCharacters() async throws {
        
        if Task.isCancelled { return }
        
        do {
            let response: CharacterList = try await interactor.getListOfCharacters(page: currentPage, pageSize: Constants.pageSize)
            await MainActor.run {
                characters.append(contentsOf: response.data)
            }
        }
        catch {
                print(error.localizedDescription)
            currentPage -= 1
        }
    }
    
    func requestMoreCharacters(_ element: Character) async {
        
        if Task.isCancelled { return }
        
        if element._id == characters[characters.count - Constants.pageThreshold]._id {
            currentPage += 1
            do {
                try await getListOfCharacters()
                
            }
            catch {
                print(error.localizedDescription)
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
        if isFavourite(character) {
            return
        }
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
