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
    let cacheManager = CacheManager()
    
    func getCharactersData(url: String) -> AnyPublisher<CharactersResponseData, Error> {
        guard let urlData = URL(string: url) else { fatalError("Invalid URL") }

        return Future { promise in
            Task {
                do {
                    if let chachedData = await self.cacheManager.getCharactersData(for: url) {
                        promise(.success(chachedData))
                    } else {
                        let urlRequest = URLRequest(url: urlData)
                        let (data, response) = try await URLSession.shared.data(for: urlRequest)
                        let charactersData = try await self.decodeCharactersData(response: response, data: data)
                        await self.cacheManager.setCharactersData(charactersData, for: url)
                        promise(.success(charactersData))
                    }
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
                        let homeworldName = try await self.getHomeworldName(from: character.homeworld)
                        let filmTitles = try await self.getFilmTitles(from: character.films)

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

    private func getHomeworldName(from url: String) async throws -> String {
        if let cachedHomeworldName = await cacheManager.getHomeworldName(for: url) {
            return cachedHomeworldName
        }
        
        guard let dataUrl = URL(string: url) else { throw ResponseError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: dataUrl)
        let homeworld = try JSONDecoder().decode(Homeworld.self, from: data)

        await cacheManager.setHomeworldName(homeworld.name, for: url)
        return homeworld.name
    }

    private func getFilmTitles(from urls: [String]) async throws -> [String] {
        var titles: [String] = []

        for url in urls {
            if let cachedFilms = await cacheManager.getFilmTitles(for: url) {
                titles.append(cachedFilms)
            } else {
                guard let dataUrl = URL(string: url) else { continue }
                let (data, _) = try await URLSession.shared.data(from: dataUrl)
                let film = try JSONDecoder().decode(Film.self, from: data)

                await cacheManager.setFilmTitle(film.title, for: url)
                titles.append(film.title)
            }
        }

        return titles
    }
}
