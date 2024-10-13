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
    @State private var showGamePlay: Bool = false

    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            topBarAndButtons

            Text(viewModel.currentRule.name)
                .contentTransition(.numericText())
                .font(.body)
            
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
        .sheet(isPresented: $showGamePlay) {
            GamePlayView(game: gameData)
        }
        .onDisappear() {
            viewModel.stopSounds()
        }
    }
    
    // Left & right buttons and the score in the middle
    var topBarAndButtons: some View {
        HStack {
            Button(action: { showGamePlay.toggle() }) {
                Image(systemName: "questionmark.circle.fill")
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Show game rules")
            
            Spacer()
            
            Text(viewModel.score.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
            Spacer()
            
            Button(action: { viewModel.reset() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Restart the game")
            
            Button(action: { viewModel.toggleSounds() }) {
                Image(systemName: viewModel.speakerIcon)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    WordCraftView(gameData: Games().games.first(where: {$0.id == "wordcraft"})!)
}
