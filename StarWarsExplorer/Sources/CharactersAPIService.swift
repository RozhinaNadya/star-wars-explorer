//
//  CharactersAPIService.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Foundation
import Combine

protocol ICharactersAPIService {
    func getCharactersData() -> AnyPublisher<CharactersResponseData, Error>
}

struct Homeworld: Codable {
    let name: String
}

struct Film: Codable {
    let title: String
}

class CharactersAPIService: ICharactersAPIService {
    static let shared = CharactersAPIService()
    private init() { }

    func getCharactersData() -> AnyPublisher<CharactersResponseData, Error> {
        guard let url = URL(string: .initialUrl) else { fatalError("Something wrong with URL") }

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
                        let homeworldName = character.homeworld != nil ? try await self.fetchHomeworldName(from: character.homeworld) : "unknown"
                        let filmTitles = try await self.fetchFilmTitles(from: character.films)

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

    private func fetchHomeworldName(from url: String) async throws -> String {
        guard let url = URL(string: url) else { throw ResponseError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let homeworld = try JSONDecoder().decode(Homeworld.self, from: data)
        return homeworld.name
    }

    private func fetchFilmTitles(from urls: [String]) async throws -> [String] {
        var titles: [String] = []

        for url in urls {
            guard let url = URL(string: url) else { continue }
            let (data, _) = try await URLSession.shared.data(from: url)
            let film = try JSONDecoder().decode(Film.self, from: data)
            titles.append(film.title)
        }

        return titles
    }
}

private extension String {
    static let initialUrl = "https://swapi.dev/api/people/"
}
