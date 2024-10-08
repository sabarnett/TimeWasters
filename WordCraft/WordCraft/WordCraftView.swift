//
//  ContentView.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//

import SwiftUI

public struct WordCraftView: View {
    @State private var viewModel = ViewModel()

    public init() { }
    
    public var body: some View {
        VStack {
            HStack {
                Text(viewModel.currentRule.name)
                    .contentTransition(.numericText())

                Spacer()

                Text("**Score:** \(viewModel.score)")
            }
            .font(.title)

            HStack(spacing: 5) {
                GameBoardView(viewModel: viewModel)
                RecentWordsView(viewModel: viewModel)
            }
        }
        .padding()
        .fixedSize()
    }
}

#Preview {
    WordCraftView()
}
