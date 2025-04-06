//
//  CharactersListItemView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import SwiftUI

struct CharactersListItemView: View {
    var item: CharacterListItem
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 16))
                .bold()
            Divider()
                .background(Color.black)
                .frame(height: 40)
            Text(item.filmTitles.joined(separator: "\n"))
                .padding(.leading,10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 12))
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? .white : .white.opacity(0.7))
        .cornerRadius(10)
    }
}

#Preview {
    let character = CharacterListItem(name: "Anakin Skywalker", filmTitles: ["film1", "film2", "film3", "film4", "film5", "film1", "film2", "film3", "film4", "film5"])
    CharactersListItemView(item: character, isSelected: false)
}
