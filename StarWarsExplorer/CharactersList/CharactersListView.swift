//
//  CharactersListView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import SwiftUI

struct CharactersListView: View {
    @EnvironmentObject var viewModel: CharacterListViewModel
    @State private var selectedCharacter: Character?
    @State private var isShowingDetail = false

    private let verticalGridlayout = [GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: verticalGridlayout, spacing: 10) {
                if let list = viewModel.characters {
                    ForEach(list) { character in
                        CharactersListItemView(item: viewModel.getListItem(character: character))
                            .onTapGesture {
                                selectedCharacter = character
                                isShowingDetail = true
                            }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.horizontal, 10)
        }
        .sheet(isPresented: $isShowingDetail) {
            if let selectedCharacter = selectedCharacter {
                CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: selectedCharacter))
            }
        }
        .onChange(of: selectedCharacter) {
            // Ensure that selectedCharacter is updated to do not show empty modalView
            if selectedCharacter != nil {
                isShowingDetail = true
            }
        }
    }
}
