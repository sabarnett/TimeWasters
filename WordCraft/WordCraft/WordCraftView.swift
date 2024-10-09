//
//  ContentView.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//

import SwiftUI
import SharedComponents

public struct WordCraftView: View {
    @State private var viewModel = ViewModel()
    
    @State private var gameData: Game

    public init(gameData: Game) {
        self.gameData = gameData
    }
    
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
    WordCraftView(gameData: Games().games.first(where: {$0.id == "wordcraft"})!)
}
