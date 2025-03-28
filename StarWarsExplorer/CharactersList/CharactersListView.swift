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
            if viewModel.characters.isEmpty {
                ProgressView()
                    .tint(Color.white)
            } else {
                ScrollView {
                    LazyVGrid(columns: verticalGridlayout, spacing: 10) {
                        ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                            CharactersListItemView(item: viewModel.getListItem(character: character))
                                .onAppear {
                                    viewModel.loadMoreCharactersIfNeeded(currentIndex: index)
                                }
                                .onTapGesture {
                                    selectedCharacter = character
                                    isShowingDetail = true
                                }
                        }
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .tint(Color.white)
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
            }
        }
    }
}
