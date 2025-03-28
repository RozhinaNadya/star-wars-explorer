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
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            if let list = viewModel.characters {
                ScrollView {
                    LazyVGrid(columns: verticalGridlayout, spacing: 10) {
                        ForEach(list) { character in
                            CharactersListItemView(item: viewModel.getListItem(character: character))
                                .onTapGesture {
                                    selectedCharacter = character
                                    isShowingDetail = true
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .sheet(isPresented: $isShowingDetail) {
                    if let selectedCharacter = selectedCharacter {
                        CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: selectedCharacter))
                            .presentationDetents([.fraction(0.4)])
                    }
                }
                .onChange(of: selectedCharacter) {
                    // Ensure that selectedCharacter is updated to do not show empty modalView
                    if selectedCharacter != nil {
                        isShowingDetail = true
                    }
                }
            } else {
                ProgressView()
                    .tint(Color.white)
            }
        }
    }
}
