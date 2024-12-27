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

    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            topBarAndButtons
            Spacer()
            
            HStack(spacing: 2) {
                GameBoardView(model: model)
                    .disabled(model.gameState != .playerMove)
                ScoresView(model: model)
            }
            
            Text(model.statusMessage)
                .font(.title)
                .padding()
        }
        .sheet(isPresented: $model.showGamePlay) {
            GamePlayView(game: gameData)
        }
        .padding()
    }
    
    var topBarAndButtons: some View {
        HStack {
            Button(action: { model.showGamePlay.toggle() }) {
                Image(systemName: "questionmark.circle.fill")
            }
            .buttonStyle(.plain)
            .help("Show game rules")
            
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

//            Button(action: { model.toggleSounds() }) {
//                Image(systemName: model.speakerIcon)
//            }
//            .buttonStyle(.plain)
//            .help("Toggle sound effects")
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
