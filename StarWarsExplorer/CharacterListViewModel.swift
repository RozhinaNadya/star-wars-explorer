//
//  CharacterListViewModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Combine
import Foundation

class CharacterListViewModel: ObservableObject {
    @Published var characterResponseData: CharactersResponseData?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getCharactersData()
    }
    
    func getCharactersData() {
        CharactersAPIService.shared.getCharactersData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: {
                self.characterResponseData = $0
            }).store(in: &cancellables)
    }
    
}
