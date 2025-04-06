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
    @Published var selectedCharacter: Character?
    @Published var isLoadingMore = false
    @Published var isFirstLoad = true
    @Published var searchQuery = ""
    @Published var showEndOfList = false
    var nextPage: String?

    private var cancellables = Set<AnyCancellable>()
    private var fetchedPages = Set<String>() // To avoid multiple concurrent fetches
    
    let apiService: ICharactersAPIService

    init(isPreview: Bool = false, apiService: ICharactersAPIService = CharactersAPIService.shared) {
        self.apiService = apiService
        if !isPreview {
            getCharactersData(url: .initialUrl)
            setupSearchSubscription()
        }
    }

    func getListItem(character: Character) -> CharacterListItem {
        CharacterListItem(name: character.name, filmTitles: character.films)
    }

    func getCharactersData(url: String) {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        let fetchUrl = url
        fetchedPages.insert(fetchUrl)

        apiService.getCharactersData(url: url)
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
        let searchUrl = searchQuery == "" ? .initialUrl : .initialUrl + .searchPath + searchQuery
        let fetchUrl = searchUrl
        fetchedPages.insert(fetchUrl)
        characters = []
        getCharactersData(url: searchUrl)
    }
    
    func loadMoreCharactersIfNeeded(currentIndex: Int) {
        let thresholdIndex = characters.count - .minItemsToLoadMore
            guard currentIndex >= thresholdIndex, !isLoadingMore else { return }

        if let nextPage = nextPage {
            getCharactersData(url: nextPage)
        }
    }
    
    func getDetails(character: Character) {
        Task {
            let homeworldName = await getCharacterHomeworld(url: character.homeworld)
            let formattedCharacter = Character(
                name: character.name,
                height: character.height,
                birthYear: character.birthYear,
                gender: character.gender,
                homeworld: homeworldName,
                films: character.films
            )

            await MainActor.run {
                self.selectedCharacter = formattedCharacter
            }
        }
    }
    
    func getCharacterHomeworld(url: String) async -> String {
        do {
            return try await apiService.getHomeworldName(from: url)
        } catch {
            return "Classified 🤐"
        }
    }

    private func setupSearchSubscription() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.searchCharacters()
            }
            .store(in: &cancellables)
    }
}

private extension String {
    static let initialUrl = "https://swapi.dev/api/people/"
    static let searchPath = "?search="
}

private extension Int {
    static let minItemsToLoadMore = 5
}
