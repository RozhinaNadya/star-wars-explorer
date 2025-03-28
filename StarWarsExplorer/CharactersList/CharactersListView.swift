//
//  CharactersListView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-27.
//

import SwiftUI

struct CharactersListView: View {
    @EnvironmentObject var viewModel: CharacterListViewModel
    
    private let verticalGridlayout = [GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: verticalGridlayout, spacing: 10) {
                if let list = viewModel.characters {
                    ForEach(list) { item in
                        CharactersListItemView(item: viewModel.getListItem(character: item))
                    }
                } else {
                    ProgressView()
                }
                
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    CharactersListView()
}
