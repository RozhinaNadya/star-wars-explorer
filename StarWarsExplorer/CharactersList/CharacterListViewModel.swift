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
    @Published var showEmptyResult = false
    @Published var isLoadingMore = false
    @Published var isFirstLoad = true
    @Published var searchQuery = ""
    @Published var showEndOfList = false
    var nextPage: String?

    private var cancellables = Set<AnyCancellable>()
    private var fetchedPages = Set<String>() // To avoid multiple concurrent fetches

    init() {
        getCharactersData(url: .initialUrl)
        setupSearchSubscription()
    }

    func getListItem(character: Character) -> CharacterListItem {
        CharacterListItem(name: character.name, filmTitles: character.films)
    }

    func getCharactersData(url: String) {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        let fetchUrl = url
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
                self.showEmptyResult = self.characters.isEmpty
                self.showEndOfList = self.nextPage == nil && !self.showEmptyResult
            })
            .store(in: &cancellables)
    }

    func searchCharacters() {
        characters = []
        let searchUrl = .initialUrl + .searchPath + searchQuery
        getCharactersData(url: searchUrl)
    }

    private func setupSearchSubscription() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.searchCharacters()
            }
            .store(in: &cancellables)
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
