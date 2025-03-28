//
//  CharacterListViewModel.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Combine
import Foundation

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var nextPage: String?
    @Published var isLoadingMore = false

    private var cancellables = Set<AnyCancellable>()
    private let minItemsToLoadMore = 5

    init() {
        getCharactersData()
    }

    func getListItem(character: Character) -> CharacterListItem {
        CharacterListItem(name: character.name, filmTitles: character.films)
    }

    func getCharactersData(url: String = .initialUrl) {
        guard !isLoadingMore else { return }
        isLoadingMore = true

        CharactersAPIService.shared.getCharactersData(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.isLoadingMore = false
            }, receiveValue: { response in
                self.nextPage = response.next
                self.characters.append(contentsOf: response.results)
                self.isLoadingMore = false
            })
            .store(in: &cancellables)
    }

    func loadMoreCharactersIfNeeded(currentIndex: Int) {
        let thresholdIndex = characters.count - minItemsToLoadMore
            guard currentIndex >= thresholdIndex, !isLoadingMore else { return }

        if let nextPage = nextPage {
            getCharactersData(url: nextPage)
        }
    }
}
