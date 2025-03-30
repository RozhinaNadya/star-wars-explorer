//
//  CharacterDetailsViewModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-28.
//

import Foundation

enum Gender: String {
    case male
    case female
    case hermaphrodite
    
    var presentedValue: String {
        switch self {
        case .male:
            return "♂"
        case .female:
            return "♀"
        case .hermaphrodite:
            return "⚥"
        }
    }
}

class CharacterDetailsViewModel {
    @Published var character: Character
    @Published var details: [Detail] = []
    
    init(character: Character) {
        self.character = character
        
        getDetails()
    }
    
    func getDetails() {
        let gender = Gender(rawValue: character.gender)?.presentedValue ?? character.gender
        details = [
            Detail(title: "Gender", value: gender),
            Detail(title: "Birth year", value: character.birthYear),
            Detail(title: "Height", value: character.height),
        ]
    }
}
