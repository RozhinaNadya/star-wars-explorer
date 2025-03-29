//
//  CharactersAPIService.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Foundation
import Combine

protocol ICharactersAPIService {
    func getCharactersData(url: String) -> AnyPublisher<CharactersResponseData, Error>
}

struct Homeworld: Codable {
    let name: String
}

struct Film: Codable {
    let title: String
}

class CharactersAPIService: ICharactersAPIService {
    static let shared = CharactersAPIService()
    private let cacheQueue = DispatchQueue(label: "CharactersAPIService.CacheQueue") // Serial Queue for thread safety
    private var homeworldCache = [String: String]()
    private var filmCache = [String: String]()
    
    init() {}

    func getCharactersData(url: String) -> AnyPublisher<CharactersResponseData, Error> {
        guard let url = URL(string: url) else { fatalError("Invalid URL") }

        let urlRequest = URLRequest(url: url)

        return Future { promise in
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(for: urlRequest)
                    let charactersData = try await self.decodeCharactersData(response: response, data: data)
                    promise(.success(charactersData))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func decodeCharactersData(response: URLResponse, data: Data?) async throws -> CharactersResponseData {
        guard let data else { throw ResponseError.decodeCharactersDataError }

        var charactersData = try JSONDecoder().decode(CharactersResponseData.self, from: data)
        var updatedCharacters: [Character] = []

        await withTaskGroup(of: Character?.self) { group in
            for character in charactersData.results {
                group.addTask {
                    do {
                        let homeworldName = try await self.getCachedHomeworldName(from: character.homeworld)
                        let filmTitles = try await self.getCachedFilmTitles(from: character.films)

                        return Character(
                            name: character.name,
                            height: character.height,
                            birthYear: character.birthYear,
                            gender: character.gender,
                            homeworld: homeworldName,
                            films: filmTitles
                        )
                    } catch {
                        return nil
                    }
                }
            }

            for await updatedCharacter in group {
                if let updatedCharacter = updatedCharacter {
                    updatedCharacters.append(updatedCharacter)
                }
            }
        }

        charactersData.results = updatedCharacters
        return charactersData
    }

    private func getCachedHomeworldName(from url: String) async throws -> String {
        if let cachedName = cacheQueue.sync(execute: { homeworldCache[url] }) {
            return cachedName
        }
        
        guard let dataUrl = URL(string: url) else { throw ResponseError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: dataUrl)
        let homeworld = try JSONDecoder().decode(Homeworld.self, from: data)

        cacheQueue.sync {
            homeworldCache[url] = homeworld.name
        }

        return homeworld.name
    }

    private func getCachedFilmTitles(from urls: [String]) async throws -> [String] {
        var titles: [String] = []

        for url in urls {
            if let cachedTitle = cacheQueue.sync(execute: { filmCache[url] }) {
                titles.append(cachedTitle)
            } else {
                guard let dataUrl = URL(string: url) else { continue }
                let (data, _) = try await URLSession.shared.data(from: dataUrl)
                let film = try JSONDecoder().decode(Film.self, from: data)

                cacheQueue.sync {
                    filmCache[url] = film.title
                }
                titles.append(film.title)
            }
        }

        return titles
    }
}
