//
//  StarWarsExplorerApp.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import SwiftUI

@main
struct StarWarsExplorerApp: App {
    var characterListViewModel = CharacterListViewModel()
    
    var body: some Scene {
        WindowGroup {
            CharactersListView()
                .environmentObject(characterListViewModel)
        }
    }
}
