//
//  CharactersListItemView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import SwiftUI

struct CharactersListItemView: View {
    var item: CharacterListItem
    
    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text(item.filmTitles.joined(separator: ", "))
        }
    }
}

#Preview {
    let character = CharacterListItem(name: "Anakin Skywalker", filmTitles: ["film1", "film2", "film3", "film4", "film5", "film1", "film2", "film3", "film4", "film5"])
    CharactersListItemView(item: character)
}
