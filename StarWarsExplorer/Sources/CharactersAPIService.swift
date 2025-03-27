//
//  CharactersAPIService.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import Foundation
import Combine

protocol ICharactersAPIService {
    func getCharactersData() -> AnyPublisher<CharacterResponse, Error>
}

class CharactersAPIService: ICharactersAPIService {
    static let shared = CharactersAPIService()

    private init() { }
    func getCharactersData() -> AnyPublisher<CharacterResponse, Error> {
        guard let url = URL(string: .charactersDataUrl) else { fatalError("Someting wrong with URL") }

        let urlRequest = URLRequest(url: url)

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap {
                try self.decodeCharactersData(response: $0.response, data: $0.data)
            }
            .eraseToAnyPublisher()
    }
    
    private func decodeCharactersData(response: URLResponse, data: Data?) throws -> CharacterResponse {
        guard let data else { throw ResponseError.decodeCharactersDataError }

        let charactersData = try JSONDecoder().decode(CharacterResponse.self, from: data)
        return charactersData
    }
}

private extension String {
    static let charactersDataUrl = "https://swapi.dev/api/people/"
}
