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
            HStack {
                Text("Toolbar goes here")
                Button(action: { model.newGame() }, label: { Text("New Game")})
                Button(action: { model.showHint() }, label: { Text("Hint")})
            }
            .disabled(model.gameState != .playerMove)
            
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
}

#Preview {
    OthelloView(gameData: Games().games.first(where: { $0.id == "othello" } )!)
}
