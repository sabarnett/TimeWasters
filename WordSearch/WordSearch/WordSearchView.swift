//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 03/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct WordSearchView: View {
    @State private var gameData: Game

    @State private var game: WordSearchViewModel = .init()
    @State private var showGamePlay: Bool = false
    
    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    var viewWidth: CGFloat {
        (Constants.tileSize + 2) * CGFloat(Constants.tileCountPerRow)
        + Constants.wordListWidth
        + 32.0
    }
    
    public var body: some View {
        ZStack {
            // Game board
            VStack {
                ZStack {
                    toggleButtons
                    gameStatusDisplay
                }
                
                HStack(spacing: 8) {
                    ZStack {
                        GameBoardView(game: game)
                        MatchedWordsView(game: game)
                    }
                    .frame(width: (Constants.tileSize + 2) * CGFloat(Constants.tileCountPerRow))
                    
                    List {
                        ForEach(game.words, id: \.id) { word in
                            Text(word.word)
                                .font(.system(size: 18))
                                .strikethrough(word.found)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .frame(width: Constants.wordListWidth)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .sheet(isPresented: $showGamePlay) {
                GamePlayView(game: gameData)
            }

            // Game over view
            if game.gameState == .endOfGame {
                GameOverView(restart: {
                    game.newGame()
                }, timeExpired: false)
            }
            
        }
        .frame(width: viewWidth)
    }
    
    /// Handles any toggle buttons to display in the scores area. We do these separately to
    /// the score display because we want the scores to be centered regardless of how many
    /// buttons we have in the buttons area.
    private var toggleButtons : some View {
        HStack {
            Button(action: {
                //model.stopSounds()
                showGamePlay.toggle()
            }) {
                Image(systemName: "questionmark.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Show the game play")
            
            Button(action: {
                //model.stopSounds()
                //showLeaderBoard.toggle()
            }) {
                Image(systemName: "trophy.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Show the leader board")
            
            Spacer()
            
            Button(action: { game.newGame() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Start a new game")
            
            Button(action: {
                //model.toggleSounds()
            }) {
                Image(systemName: game.speakerIcon)
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Toggle sounds")
            
        }
        .padding([.horizontal,.top])
    }
    
    /// Displays the current selected bomb count and the number of seconds elapsed. It also
    /// has a button in betweenthe two scores that allows the user to restart the game. It sits
    /// above the game play area, in the middle. Ther may be buttons to the right and
    /// left. These are produced by the toggleButtons function.
    private var gameStatusDisplay : some View {
        HStack(spacing: 0) {
            // Matched items
            // Seconds elapsed
            Text(game.time.formatted(.number.precision(.integerLength(4))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
                .help("Time taken, so far.")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .background(.black)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.top)
    }

}

#Preview {
    WordSearchView(gameData: Games().games.first(where: {$0.id == "wordSearch"})!)
}
