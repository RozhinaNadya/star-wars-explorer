//
//  CharacterModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Foundation

struct CharacterResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Character]
}

struct Character: Codable {
    let name: String
    let height: String
    let birthYear: String
    let gender: String
    let homeworld: String
    let films: [String]
    
    enum CodingKeys: String, CodingKey {
        case name, height, gender, homeworld, films
        case birthYear = "birth_year"
    }
}
