//
//  MockedInteractor.swift
//  DisneyCharactersTests
//
//  Created by Tiziano Bruni on 25/04/2024.
//

import Combine
import DisneyCharacters
import Foundation

enum TestErrorType: Error {
    case failedResponse
}

class MockedInteractor: InteractorProviding {
    func getGenericData<T>(url: URL, page: Int, pageSize: Int) async throws -> AnyPublisher<T, any Error> where T : Decodable {
        if failResponse {
            throw TestErrorType.failedResponse
        }
        
        let data = Bundle.main.decode(T.self, from: "mocked_response.json")
        return Just(data)
            .receive(on: RunLoop.main)
            .setFailureType(to: (any Error).self)
            .eraseToAnyPublisher()
    }
    
    var failResponse = false
    
//    func getListOfCharacters<T>(page: Int, pageSize: Int) async throws -> T where T : Decodable {
//        
//        if failResponse {
//            throw TestErrorType.failedResponse
//        }
//        
//        let response = Bundle.main.decode(T.self, from: "mocked_response.json")
//        return response
//    }
}
