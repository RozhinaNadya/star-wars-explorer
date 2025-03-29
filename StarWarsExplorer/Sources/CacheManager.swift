//
//  CacheManager.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-29.
//

import Foundation

class CacheManager {
    private let cacheQueue = DispatchQueue(label: "CacheManager.Queue")
    private var homeworldCache = [String: String]()
    private var filmCache = [String: String]()
    
    func getHomeworldName(for url: String) -> String? {
        return cacheQueue.sync { homeworldCache[url] }
    }
    
    func setHomeworldName(_ name: String, for url: String) {
        cacheQueue.sync { homeworldCache[url] = name }
    }
    
    func getFilmTitles(for url: String) -> String? {
        return cacheQueue.sync { filmCache[url] }
    }
    
    func setFilmTitle(_ title: String, for url: String) {
        cacheQueue.sync { filmCache[url] = title }
    }
}
