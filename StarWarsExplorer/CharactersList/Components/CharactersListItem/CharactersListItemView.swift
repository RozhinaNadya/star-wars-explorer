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
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 14))
            Divider()
                .frame(height: 40)
            Text(item.filmTitles.joined(separator: ", "))
                .padding(.leading,10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 12))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    let character = CharacterListItem(name: "Anakin Skywalker", filmTitles: ["film1", "film2", "film3", "film4", "film5", "film1", "film2", "film3", "film4", "film5"])
    CharactersListItemView(item: character)
}
