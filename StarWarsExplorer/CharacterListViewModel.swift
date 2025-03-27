//
//  CharacterListViewModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Combine
import Foundation

class CharacterListViewModel: ObservableObject {
    @Published var character: Character?
    @Published var charactersList: [CharacterListItem]?
    @Published var nextPage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getCharactersData()
    }
    
    func getCharactersData() {
        CharactersAPIService.shared.getCharactersData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.nextPage = response.next                
                self.charactersList = response.results.map { character in
                    CharacterListItem(name: character.name, filmTitles: character.films)
                }
            }).store(in: &cancellables)
    }
    
}
