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
            if viewModel.isFirstLoad {
                ProgressView()
                    .tint(Color.white)
            } else {
                VStack {
                    header
                        .padding(.bottom, 16)
                    
                    starWarsSearchBar
                        .padding(.bottom, 10)

                    if viewModel.characters.isEmpty {
                        ProgressView()
                            .tint(Color.white)
                        Spacer()
                    } else {
                        ScrollView {
                            charactersList

                            if viewModel.isLoadingMore {
                                ProgressView()
                                    .tint(.white)
                            } else if viewModel.nextPage == nil {
                                endOfList
                                    .padding(.vertical, 20)
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

    private var header: some View {
        VStack {
            Text("Star Wars Explorer")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Tap to learn more about a character")
                .foregroundColor(.white.opacity(0.7))
                .font(.subheadline)
        }
    }

    private var starWarsSearchBar: some View {
        TextField("Search characters...", text: $viewModel.searchQuery)
            .padding(7)
            .background(.clear)
            .foregroundColor(.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1))
            .onChange(of: viewModel.searchQuery) {
                viewModel.searchCharacters()
            }
    }

    private var charactersList: some View {
        LazyVGrid(columns: verticalGridlayout, spacing: 10) {
            ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                CharactersListItemView(item: viewModel.getListItem(character: character))
                    .onAppear {
                        viewModel.loadMoreCharactersIfNeeded(currentIndex: index)
                    }
                    .onTapGesture {
                        selectedCharacter = character
                    }
            }
        }
    }

    private var endOfList: some View {
        Text("May the force be with you 💫")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.8))
    }
}
