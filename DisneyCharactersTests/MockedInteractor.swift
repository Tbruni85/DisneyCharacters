//
//  MockedInteractor.swift
//  DisneyCharactersTests
//
//  Created by Tiziano Bruni on 25/04/2024.
//

import Foundation
import DisneyCharacters

enum TestErrorType: Error {
    case failedResponse
}

class MockedInteractor: InteractorProviding {
    
    var failResponse = false
    
    func getListOfCharacters<T>(page: Int, pageSize: Int) async throws -> T where T : Decodable {
        
        if failResponse {
            throw TestErrorType.failedResponse
        }
        
        let response = Bundle.main.decode(T.self, from: "mocked_response.json")
        return response
    }
}
