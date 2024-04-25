//
//  MockData.swift
//  DisneyCharactersTests
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation
@testable import DisneyCharacters

struct MockedData {
    
    static let mockCharacter = Character(_id: 112,
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
    
    static let mockCharacter2 = Character(_id: 101,
                                   name: "Lion King",
                                   imageUrl: nil,
                                   url: "https://api.disneyapi.dev/characters/101",
                                   films: ["Lion King 1", "Lion King 2"],
                                   shortFilms: [],
                                   tvShows: ["Lion King (TV series)"],
                                   videoGames: ["Kingdom Hearts III"],
                                   parkAttractions: [],
                                   allies: [],
                                   enemies: [],
                                   sourceUrl: "https://disney.fandom.com/wiki/Achilles_(Lion_king)")
}
