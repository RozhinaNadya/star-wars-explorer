//
//  CacheManager.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-29.
//

import Foundation

actor CacheManager {
    private let cacheQueue = DispatchQueue(label: "CacheManager.Queue")
    private var homeworldCache = [String: String]()
    private var filmCache = [String: String]()
    private var charactersCache = [String: CharactersResponseData]()
    
    func getHomeworldName(for url: String) -> String? {
        homeworldCache[url]
    }
    
    func setHomeworldName(_ name: String, for url: String) {
        homeworldCache[url] = name
    }
    
    func getFilmTitles(for url: String) -> String? {
        filmCache[url]
    }
    
    func setFilmTitle(_ title: String, for url: String) {
        filmCache[url] = title
    }
    
    func getCharactersData(for url: String) -> CharactersResponseData? {
        charactersCache[url]
    }
    
    func setCharactersData(_ data: CharactersResponseData, for url: String) {
        charactersCache[url] = data
    }
}
