//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 20/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct MatchedPairsView: View {
    @State public var gameData: Game
    @State var model: MatchedPairsGameModel
    
    @State private var showGamePlay: Bool = false
    @State private var showLeaderBoard: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var gamePlayColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(80.00), spacing: 3), count: model.columns)
    }
    
    public init(gameData: Game) {
        self.gameData = gameData
        self.model = MatchedPairsGameModel()
    }
    
    public var body: some View {
        ZStack {
            VStack {
                ZStack {
                    toggleButtons
                    gameStatusDisplay
                }
                LazyVGrid(columns: gamePlayColumns) {
                    ForEach(model.tiles) { tile in
                        TileView(tile: tile) {
                            withAnimation {
                                model.select(tile)
                            }
                        }
                        .environment(model)
                    }
                }
                .padding()
                .disabled(model.gameState != .playing)
            }

            if model.gameState == .gameOver {
                GameOverView() {
                    withAnimation {
                        model.newGame()
                    }
                }
            }
        }
        .sheet(isPresented: $showGamePlay, onDismiss: {
//            if minePlaySounds {
//                playSound(tickingURL, repeating: true)
//            }
        }) { GamePlayView(game: gameData) }
        
        .sheet(isPresented: $showLeaderBoard, onDismiss: {
//            if minePlaySounds {
//                playSound(tickingURL, repeating: true)
//            }
        }) {
            Text("Leader Board")
//            LeaderBoardView(leaderBoard: game.leaderBoard,
//                            initialTab: game.mineGameDifficulty)
        }
        
        .onReceive(timer) { _ in
            if showGamePlay || showLeaderBoard { return }
            guard model.gameState == .playing else { return }
            guard model.time < 999 else { return }
            model.time += 1
        }
    }
    
    /// Handles any toggle buttons to display in the scores area. We do these separately to
    /// the score display because we want the scores to be centered regardless of how many
    /// buttons we have in the buttons area.
    private var toggleButtons : some View {
        HStack {
            Button(action: {
//                ticking.stop()
                showGamePlay.toggle()
            }) {
                Image(systemName: "questionmark.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Show the game play")

            Button(action: {
//                ticking.stop()
                showLeaderBoard.toggle()
            }) {
                Image(systemName: "trophy.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Show the leader board")

            Spacer()
            
            Button(action: { model.newGame() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Start a new game")

            Button(action: { toggleSounds() }) {
                Image(systemName: true ? "speaker.slash.fill" : "speaker.fill")
                    .scaleEffect(2)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Toggle sounds")

        }.padding([.horizontal,.top])
    }
    
    /// Displays the current selected bomb count and the number of seconds elapsed. It also
    /// has a button in betweenthe two scores that allows the user to restart the game. It sits
    /// above the game play area, in the middle. Ther may be buttons to the right and
    /// left. These are produced by the toggleButtons function.
    private var gameStatusDisplay : some View {
        HStack(spacing: 0) {
            // Matched items
            Text(model.moves.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
                .help("Number of moves so far.")
            
            Text("♦️")
            
            // Seconds elapsed
            Text(model.time.formatted(.number.precision(.integerLength(3))))
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

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    private func toggleSounds() {
//        minePlaySounds.toggle()
//        if minePlaySounds {
//            playSound(tickingURL, repeating: true)
//        } else {
//            ticking.stop()
//        }
    }
}

#Preview {
    MatchedPairsView(gameData: Games().games.first(where: { $0.id == "matchedPairs" } )!)
}
