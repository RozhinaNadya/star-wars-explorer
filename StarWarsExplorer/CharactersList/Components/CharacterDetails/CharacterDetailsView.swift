//
//  CharacterDetailsView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-28.
//

import SwiftUI

struct CharacterDetailsView: View {
    var viewModel: CharacterDetailsViewModel

    var body: some View {
        VStack {
            Text(viewModel.character.name)
                .font(.system(size: 24))
                .bold()
            Text(viewModel.character.homeworld)
                .foregroundColor(.black.opacity(0.8))
                .font(.system(size: 24))
                .padding(.top, 3)
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(viewModel.details) { item in
                    DetailView(detail: item)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    let character = Character(name: "Anakin Skywalker", height: "178", birthYear: "1977", gender: "male", homeworld: "Tatooine", films: [])
    CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: character))
}
