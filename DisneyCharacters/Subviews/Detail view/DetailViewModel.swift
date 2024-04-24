//
//  DetailViewModel.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    @Published var isFilmSectionExpanded = true
    @Published var isShortFilmSectionExpanded = true
    @Published var isTVShowsSectionExpanded = true
    @Published var isVideogamesSectionExpanded = true
    @Published var isParkAttractionSectionExpanded = true
    @Published var isAlliesSectionExpanded = true
    @Published var isEnemiesSectionExpanded = true
}
