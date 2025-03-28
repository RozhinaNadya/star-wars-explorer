//
//  DetailView.swift
//  StarWarsExplorer
//
//  Created by Nadya Rozhina on 2025-03-28.
//

import SwiftUI

struct DetailView: View {
    var detail: Detail

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: 100, height: 100)
            VStack {
                Text(detail.title)
                    .font(.system(size: 16))
                Text(detail.value)
                    .font(.system(size: 18))
                    .bold()
            }
            .foregroundColor(.yellow)
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    let detail = Detail(title: "Height", value: "178 cm")
    DetailView(detail: detail)
}
