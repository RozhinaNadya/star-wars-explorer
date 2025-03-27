//
//  CharacterListItem.swift
//  StarWarsExplorer
//
//  Created by Rozhina,Nadya on 2025-03-27.
//

import Foundation

struct CharacterListItem: Identifiable {
    var id = UUID()
    var name: String
    var filmTitles: [String]
}
