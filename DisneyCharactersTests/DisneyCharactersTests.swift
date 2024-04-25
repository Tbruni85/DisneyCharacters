//
//  DisneyCharactersTests.swift
//  DisneyCharactersTests
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import XCTest
@testable import DisneyCharacters

final class DisneyCharactersTests: XCTestCase {
    
    var viewModel: DisneyCharactersMainViewModel!
    var mockInteractor: MockedInteractor!
    
    override func setUpWithError() throws {
        mockInteractor = MockedInteractor()
        viewModel = DisneyCharactersMainViewModel(interactor: mockInteractor)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockInteractor = nil
    }
    
    func test_adding_to_favourites() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        
        XCTAssertEqual(viewModel.favouriteCharacters.count, 1)
        XCTAssertTrue(viewModel.isFavourite(MockedData.mockCharacter))
    }
    
    func test_adding_same_character_to_favourites_fails() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        viewModel.addToFavourite(MockedData.mockCharacter)
        
        XCTAssertEqual(viewModel.favouriteCharacters.count, 1)
    }
    
    func test_file_created_when_adding_to_favourites() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        let data = try Data(contentsOf: viewModel.savePath)
        XCTAssertNotNil(data)
    }
    
    func test_load_saved_data() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        viewModel.addToFavourite(MockedData.mockCharacter2)
        
        viewModel.loadSaveData()
        
        XCTAssertEqual(viewModel.favouriteCharacters.count, 2)
    }
    
    func test_adding_characters_to_favourites() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        viewModel.addToFavourite(MockedData.mockCharacter2)
        
        XCTAssertEqual(viewModel.favouriteCharacters.count, 2)
    }
    
    func test_is_favourite() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        
        XCTAssertTrue(viewModel.isFavourite(MockedData.mockCharacter))
    }
    
    func test_remove_from_favourites() throws {
        
        viewModel.addToFavourite(MockedData.mockCharacter)
        viewModel.removeFromFavourite(MockedData.mockCharacter)
        
        XCTAssertFalse(viewModel.isFavourite(MockedData.mockCharacter))
        XCTAssertEqual(viewModel.favouriteCharacters.count, 0)
    }
    
    func test_alphabetical_sort() throws {
        let data = Bundle.main.decode(CharacterList.self, from: "mocked_response.json")
        viewModel.characters = data.data
        
        viewModel.sortBy(filter: .alphabetical)
        
        XCTAssertTrue(viewModel.characters[0].name < viewModel.characters[1].name)
    }
    
    func test_popularity_sort() throws {
        let data = Bundle.main.decode(CharacterList.self, from: "mocked_response.json")
        viewModel.characters = data.data
        
        viewModel.sortBy(filter: .popularity)
        
        XCTAssertTrue(viewModel.characters[0].films.count > viewModel.characters[1].films.count)
    }
    
    func test_fetch_data_success() async throws {
        
        try await viewModel.getListOfCharacters()
        XCTAssertTrue(viewModel.characters.count > 0)
    }
    
    func test_fetch_data_failure() async throws {
        mockInteractor.failResponse = true
        try await viewModel.getListOfCharacters()
        XCTAssertEqual(viewModel.characters.count, 0)
    }
    
    func test_request_more_data_success() async throws {
    
        for _ in 0..<10 {
            viewModel.characters.append(MockedData.mockCharacter)
        }
        
        let elementsBeforeUpdate = viewModel.characters.count
        await viewModel.requestMoreCharacters(MockedData.mockCharacter)
        XCTAssertEqual(viewModel.characters.count, elementsBeforeUpdate + DisneyCharactersMainViewModel.Constants.pageSize)
    }
    
    func test_request_more_data_failure() async throws {
        
        for _ in 0..<10 {
            viewModel.characters.append(MockedData.mockCharacter)
        }
        mockInteractor.failResponse = true

        let elementsBeforeUpdate = viewModel.characters.count
        await viewModel.requestMoreCharacters(MockedData.mockCharacter)
        XCTAssertEqual(viewModel.characters.count, elementsBeforeUpdate)
    }
}
