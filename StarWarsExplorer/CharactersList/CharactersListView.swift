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
                VStack {
                    VStack{
                        Text("Star Wars Explorer")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Tap to learn more about a character")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.subheadline)
                    }
                    .padding(.bottom, 16)
                    
                    TextField("Search characters...", text: $viewModel.searchQuery)
                        .padding(7)
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
                        .padding(.bottom, 10)
                        .onChange(of: viewModel.searchQuery) {
                            viewModel.searchCharacters()
                        }
                    
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
                                    .tint(.white)
                            }
                            if viewModel.nextPage == nil {
                                Text("May the force be with you 💫")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .sheet(isPresented: $isShowingDetail) {
                    if let selectedCharacter = selectedCharacter {
                        CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: selectedCharacter))
                            .presentationDetents([.fraction(0.4)])
                    }
                }
                .onChange(of: selectedCharacter) {
                    // Ensure that selectedCharacter is updated to do not present an empty sheet
                    if selectedCharacter != nil {
                        isShowingDetail = true
                    }
                }
            }
        }
    }
}
