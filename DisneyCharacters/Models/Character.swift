//
//  Character.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation

struct Character: Codable {
    let _id: Int
    let name: String
    let imageUrl: String?
    let url: String
    let films: [String]
    let shortFilms: [String]
    let tvShows: [String]
    let videoGames: [String]
    let parkAttractions: [String]
    let allies: [String]
    let enemies: [String]
    let sourceUrl: String
    
#if DEBUG
    static let example = Character(_id: 112,
                                   name: "Achilles",
                                   imageUrl: "https://static.wikia.nocookie.net/disney/images/d/d3/Vlcsnap-2015-05-06-23h04m15s601.png",
                                   url: "https://api.disneyapi.dev/characters/112",
                                   films: ["Hercules (film)"],
                                   shortFilms: [],
                                   tvShows: ["Hercules (TV series)"],
                                   videoGames: ["Kingdom Hearts III"],
                                   parkAttractions: [],
                                   allies: [],
                                   enemies: [],
                                   sourceUrl: "https://disney.fandom.com/wiki/Achilles_(Hercules)")
    #endif
}

struct CharacterList: Codable {
    let data: [Character]
}
