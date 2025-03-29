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
    @Published var isFirstLoad = true
    @Published var searchQuery = ""

    private var cancellables = Set<AnyCancellable>()
    private var fetchedPages = Set<String>() // Cache for fetched pages

    init() {
        getCharactersData(url: .initialUrl)
    }

    func getListItem(character: Character) -> CharacterListItem {
        CharacterListItem(name: character.name, filmTitles: character.films)
    }

    func getCharactersData(url: String) {
        let fetchUrl = url
        guard !isLoadingMore else { return }
        isLoadingMore = true
        fetchedPages.insert(fetchUrl)

        CharactersAPIService.shared.getCharactersData(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.isLoadingMore = false
            }, receiveValue: { response in
                self.nextPage = response.next
                self.characters.append(contentsOf: response.results)
                self.isFirstLoad = false
                self.isLoadingMore = false
            })
            .store(in: &cancellables)
    }

    func searchCharacters() {
        characters = []
        let searchUrl = .initialUrl + .searchPath + searchQuery
        getCharactersData(url: searchUrl)
    }

    func loadMoreCharactersIfNeeded(currentIndex: Int) {
        let thresholdIndex = characters.count - .minItemsToLoadMore
            guard currentIndex >= thresholdIndex, !isLoadingMore else { return }

        if let nextPage = nextPage {
            getCharactersData(url: nextPage)
        }
    }
}

private extension String {
    static let initialUrl = "https://swapi.dev/api/people/"
    static let searchPath = "?search="
}

private extension Int {
    static let minItemsToLoadMore = 3
}
