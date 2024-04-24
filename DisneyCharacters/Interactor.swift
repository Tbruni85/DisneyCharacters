//
//  Interactor.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation

enum RequestHandlerError: Error {
    case malformedURL
}

public protocol InteractorProviding {
    func getListOfCharacters<T : Decodable>(page: Int, pageSize: Int) async throws -> T
}

class Interactor: InteractorProviding {
    
    private struct Constants {
        static var baseUrl = "https://api.disneyapi.dev/character"
    }
    
    func getListOfCharacters<T : Decodable>(page: Int, pageSize: Int = 60) async throws -> T {
        
        guard let url = URL(string: Constants.baseUrl + "?page=\(page)&pageSize=\(pageSize)") else {
            throw RequestHandlerError.malformedURL
        }
        print(url)
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let charaterList = try decoder.decode(T.self, from: data)
            
            return charaterList
        }
        catch {
            throw error
        }
    }
}
