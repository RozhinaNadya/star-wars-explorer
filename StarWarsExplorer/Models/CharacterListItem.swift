//
//  CharacterListItem.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Foundation

struct CharacterListItem: Identifiable {
    let id = UUID()
    let name: String
    let filmTitles: [String]
}

struct Detail: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}
