//
//  DisneyCharactersApp.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

@main
struct DisneyCharactersApp: App {
    
    @StateObject var mainViewModel = DisneyCharactersViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainViewModel)
        }
    }
}
