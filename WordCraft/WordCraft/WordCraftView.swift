//
//  ContentView.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//

import SwiftUI
import SharedComponents

public struct WordCraftView: View {
    
    @AppStorage(Constants.wordcraftShowUsedWords) private var wordcraftShowUsedWords = true
    
    @State private var viewModel = WordCraftViewModel()
    @State private var gameData: Game

    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            WordCraftToolBar(viewModel: viewModel)

            WordCraftRuleView(viewModel: viewModel)
            
            HStack(spacing: 5) {
                GameBoardView(viewModel: viewModel)
                if wordcraftShowUsedWords {
                    RecentWordsView(viewModel: viewModel)
                }
            }
        }
        .padding()
        .fixedSize()
        .onKeyPress(action: { keyPress in
            viewModel.selectLetter(keyPress)
            return .handled
        })
        .onAppear() {
            viewModel.playBackgroundSound()
        }
        .sheet(isPresented: $viewModel.showGamePlay) {
            GamePlayView(game: gameData)
        }
        .onDisappear() {
            viewModel.stopSounds()
        }
    }
}

#Preview {
    WordCraftView(gameData: Games().games.first(where: {$0.id == "wordcraft"})!)
}
