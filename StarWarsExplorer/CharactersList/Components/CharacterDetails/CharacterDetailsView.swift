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
            VStack {
                Text(viewModel.character.name)
                    .bold()
                Text(viewModel.character.homeworld)
                    .foregroundColor(.black.opacity(0.7))
            }
            .font(.system(size: 24))
            .padding(20)

            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(viewModel.details) { item in
                    DetailView(detail: item)
                        .padding(.horizontal, 10)
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
