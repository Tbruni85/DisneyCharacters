//
//  URLFactory.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 03/05/2024.
//

import Foundation

class URLFactory {
    
    private struct Constants {
        static var disneyBaseUrl = "https://api.disneyapi.dev/character"
    }
    
    enum URLS {
        case disneyCharacters(pageSize: Int, page: Int)
        
        func generateUrl() -> URL? {
            switch self {
            case .disneyCharacters(let pageSize, let page):
                URL(string: Constants.disneyBaseUrl + "?page=\(page)&pageSize=\(pageSize)")
            }
        }
    }
    
    func generateUrlFor(url: URLS) throws -> URL  {
        guard let url = url.generateUrl() else {
            throw RequestHandlerError.malformedURL
        }
        
        return url
    }
}

