//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 18/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct OthelloView: View {
    
    @State public var gameData: Game
    @StateObject private var model: OthelloViewModel = OthelloViewModel()

    @State private var isGameOver: Bool = false
    @State private var showLeaderBoard: Bool = false

    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                topBarAndButtons
                    .padding()
                Spacer()
                
                HStack(spacing: 2) {
                    GameBoardView(model: model)
                    ScoresView(model: model)
                }
                
                Text(model.statusMessage)
                    .font(.title)
                    .padding()
            }
            .disabled(isGameOver)
            .sheet(isPresented: $model.showGamePlay) {
                GamePlayView(game: gameData)
            }
            
            if isGameOver {
                GameOverView(
                    restart: {
                        isGameOver = false
                        model.newGame()
                    },
                    message: model.gameState == .playerWin ? "😀 You win!" : "🤖 I win this time.",
                             buttonCaption: "New Game") 
            }
        }
        .onChange(of: model.gameState) { old, new in
            if new == .playerWin || new == .computerWin {
                isGameOver = true
            }
        }
        .padding()
        .sheet(isPresented: $showLeaderBoard) {
            LeaderBoardView(leaderBoard: model.leaderBoard,
                            initialTab: .player)
        }
        .frame(width: 700, height: 590)
    }
    
    var topBarAndButtons: some View {
        HStack {
            Button(action: { model.showGamePlay.toggle() }) {
                Image(systemName: "questionmark.circle.fill")
            }
            .buttonStyle(.plain)
            .help("Show game rules")
                        
            Button(action: { showLeaderBoard = true }) {
                Image(systemName: "trophy.circle.fill")
            }
            .buttonStyle(.plain)
            .help("Show the leader board")

            Spacer()

            Button(action: { model.showHint() }) {
                Image(systemName: "signpost.right.fill")
            }
            .buttonStyle(.plain)
            .help("Show player moves")
            .disabled(model.gameState != .playerMove)

            Button(action: { model.newGame() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
            }
            .buttonStyle(.plain)
            .help("Start a new game")

            Button(action: { model.toggleSounds() }) {
                Image(systemName: model.speakerIcon)
            }
            .buttonStyle(.plain)
            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .frame(height: 30)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    OthelloView(gameData: Games().games.first(where: { $0.id == "othello" } )!)
}
