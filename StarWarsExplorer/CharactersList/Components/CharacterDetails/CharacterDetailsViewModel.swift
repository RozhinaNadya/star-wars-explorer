//
//  CharacterDetailsViewModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-28.
//

import Foundation

class CharacterDetailsViewModel {
    @Published var character: Character
    @Published var details: [Detail] = []
    
    init(character: Character) {
        self.character = character
        
        getDetails()
    }
    
    func getDetails() {
        details = [
            Detail(title: "Gender", value: character.gender),
            Detail(title: "Birth year", value: character.birthYear),
            Detail(title: "Height", value: character.height),
        ]
    }
}
