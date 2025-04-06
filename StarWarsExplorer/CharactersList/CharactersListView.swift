//
//  CharactersListView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import SwiftUI

struct CharactersListView: View {
    @EnvironmentObject var viewModel: CharacterListViewModel

    @State private var isShowingDetail = false

    @FocusState private var searchFocus: Bool

    private let verticalGridlayout = [GridItem(.flexible())]

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .onTapGesture {
                    searchFocus = false
                }
            if viewModel.isFirstLoad {
                ProgressView()
                    .tint(Color.white)
            } else {
                VStack {
                    header
                        .padding(.bottom, 16)
                    
                    starWarsSearchBar
                        .padding(.bottom, 10)
                    
                    if viewModel.showEmptyResult {
                        emptySearchResult
                    }

                    ScrollView {
                        charactersList

                        if viewModel.isLoadingMore {
                            ProgressView()
                                .tint(.white)
                                .padding(.vertical, 20)
                        } else if viewModel.showEndOfList {
                            endOfList
                                .padding(.vertical, 20)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .sheet(isPresented: $isShowingDetail, onDismiss: { viewModel.selectedCharacter = nil }) {
                    if let selectedCharacter = viewModel.selectedCharacter {
                        CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: selectedCharacter))
                            .presentationDetents([.fraction(0.4)])
                    }
                }
                .onChange(of: viewModel.selectedCharacter) {
                    // Ensure that selectedCharacter is updated to do not present an empty sheet
                    if viewModel.selectedCharacter != nil {
                        searchFocus = false
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
        ZStack(alignment: .leading) {
            if viewModel.searchQuery.isEmpty {
                Text("Search characters...")
                    .foregroundColor(.white.opacity(0.4))
            }
            TextField("", text: $viewModel.searchQuery)
                .focused($searchFocus)
                .tint(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .foregroundColor(.white)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1))
    }

    private var charactersList: some View {
        LazyVGrid(columns: verticalGridlayout, spacing: 10) {
            ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                CharactersListItemView(
                    item: viewModel.getListItem(character: character),
                    isSelected: selectedCharacter == character)
                    .onAppear {
                        viewModel.loadMoreCharactersIfNeeded(currentIndex: index)
                    }
                    .onTapGesture {
                        viewModel.getDetails(character: character)
                    }
            }
        }
    }
    
    private var emptySearchResult: some View {
        VStack (alignment: .center) {
            ZStack {
                Rectangle()
                    .frame(width: 250, height: 250)
                    .cornerRadius(100)
                    .blur(radius: 10)

                Image("noResult")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(100)

            }
            .padding(.bottom, 20)

            Text("Find anyone with that name, I could not, on any planet in the Galaxy, sorry 🥺")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }

    private var endOfList: some View {
        Text("May the force be with you 💫")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.8))
    }
}
