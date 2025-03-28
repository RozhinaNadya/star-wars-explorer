//
//  CharacterListViewModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Combine
import Foundation

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character]?
    @Published var nextPage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getCharactersData()
    }
    
    func getListItem(character: Character) -> CharacterListItem {
        CharacterListItem(name: character.name, filmTitles: character.films)
    }
    
    func getCharactersData() {
        CharactersAPIService.shared.getCharactersData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.nextPage = response.next
                self.characters = response.results.map { character in
                    Character(
                        name: character.name,
                        height: character.height,
                        birthYear: character.birthYear,
                        gender: character.gender,
                        homeworld: character.homeworld,
                        films: character.films
                    )
                }
            }).store(in: &cancellables)
    }
}
