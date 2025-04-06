//
//  Character.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Foundation

struct CharactersResponseData: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [Character]
}

struct Character: Identifiable, Codable, Equatable {
    let id = UUID()
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

struct Homeworld: Codable {
    let name: String
}

struct Film: Codable {
    let title: String
}
