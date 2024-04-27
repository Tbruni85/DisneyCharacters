//
//  Interactor.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation
import Combine

enum RequestHandlerError: Error {
    case malformedURL
}

public protocol InteractorProviding {
    func getGenericData<T: Decodable>(page: Int, pageSize: Int) async throws -> AnyPublisher<T, Error> where T: Decodable
}

class Interactor: InteractorProviding {
    
    private var cancellable: AnyCancellable?
    
    private struct Constants {
        static var baseUrl = "https://api.disneyapi.dev/character"
    }
        
    func getGenericData<T>(page: Int, pageSize: Int) async throws -> AnyPublisher<T, any Error> where T : Decodable {
        guard let url = URL(string: Constants.baseUrl + "?page=\(page)&pageSize=\(pageSize)") else {
            throw RequestHandlerError.malformedURL
        }
        print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { $0.data }
            .receive(on: RunLoop.main)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
