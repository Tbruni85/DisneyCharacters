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
    func getGenericData<T: Decodable>(url: URL, page: Int, pageSize: Int) async throws -> AnyPublisher<T, Error> where T: Decodable
}

class Interactor: InteractorProviding {
    
    private var cancellable: AnyCancellable?
    
    func getGenericData<T>(url: URL, page: Int, pageSize: Int) async throws -> AnyPublisher<T, any Error> where T : Decodable {
        print(url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { $0.data }
            .receive(on: RunLoop.main)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
