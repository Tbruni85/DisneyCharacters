//
//  DisneyCharactersMainViewModel.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation
import Combine
import SwiftUI

class DisneyCharactersMainViewModel: ObservableObject {
    
    struct Constants {
        static var pageSize = 50
        static var pageThreshold = 10
    }
    
    enum State {
        case hasCharacters
        case noData
        case errorData
    }
    
    @Published var characters: [Character] = []
    @Published var favouriteCharacters: [Character] = []
    @Published var hasFavourites: Bool = false
    @Published var viewState: State = .noData
    var mainViewDidLoad = false
    
    var currentPage = 1
    let savePath = URL.documentsDirectory.appending(path: "FavouriteCharacters")
    private let interactor: InteractorProviding
    private var store = Set<AnyCancellable>()
    private var characterListEnded: Bool = false
    private let coordinator = Coordinator()
    private let urlFactory = URLFactory()
    
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
        
        guard !characterListEnded else {
            print("no more characters to fetch")
            return 
        }
    
        do {
            
            let url = try urlFactory.generateUrlFor(url: .disneyCharacters(pageSize: Constants.pageSize, page: currentPage))
            
            let publisher: AnyPublisher<CharacterList, Error> = try await interactor.getGenericData(url: url,
                                                                                                    page: currentPage,
                                                                                                    pageSize: Constants.pageSize)
            publisher
                .sink(receiveCompletion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .finished:
                        print("request completed")
                    case .failure(let error):
                        print("request failed with error: \(error)")
                        self.viewState = .errorData
                    }
                },
                      receiveValue: { [weak self] newList in
                    guard let self = self else { return }
                        self.characters.append(contentsOf: newList.data)
                        self.viewState = .hasCharacters
                        if newList.data.count < Constants.pageSize {
                            self.characterListEnded = true
                        }
                })
                .store(in: &store)
        }
        catch {
            print(error.localizedDescription)
            currentPage -= 1
        }
    }
    
    func requestMoreCharacters(_ element: Character) async {
        
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
            hasFavourites = favouriteCharacters.count > 0 ? true : false
        } catch {
            print("Error reading file: \(error)")
        }
    }
}

extension DisneyCharactersMainViewModel {
    
    func goTo(route: Coordinator.Routes) -> some View {
        coordinator.goTo(route: route)
    }
}
