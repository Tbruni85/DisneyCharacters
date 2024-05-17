//
//  ContentView.swift
//  DisneyCharacters
//
//  Created by Tiziano Bruni on 24/04/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var mainViewModel: DisneyCharactersMainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if mainViewModel.hasFavourites {
                    FavouriteView()
                }
                
                FilterView()
                switch mainViewModel.viewState {
                case .hasCharacters:
                    CharatersListView()
                case .noData:
                    ContentUnavailableView(label: {
                        VStack {
                            ProgressView()
                        }
                    }, description: {
                        Text("Fetching Disney characters")
                    })
                case .errorData:
                    ContentUnavailableView(label: {
                        VStack {
                            Text("Message")
                        }
                    }, description: {
                        Text("Something went wrong fetching data")
                    })
                }
            }
            .navigationTitle("Disney characters")
            .task {
                if !mainViewModel.mainViewDidLoad {
                    mainViewModel.loadSaveData()
                    do {
                        try await mainViewModel.getListOfCharacters()
                    }
                    catch {
                        print(error)
                    }
                    mainViewModel.mainViewDidLoad = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DisneyCharactersMainViewModel())
}
