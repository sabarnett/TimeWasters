//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 27/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct TicTacToeView: View {
    
    @State public var gameData: Game
    @StateObject var model = TicTacToeGameModel()
    
    let columns = [
        GridItem(.fixed(90.00), spacing: 10),
        GridItem(.fixed(90.00), spacing: 10),
        GridItem(.fixed(90.00), spacing: 10)]

    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        VStack {
            topBarAndButtons
                .padding(8)
            Spacer()

            HStack {
                LazyVGrid(columns: columns) {
                    ForEach($model.gameBoard) { $tile in
                        TileView(tile: $tile) {
                            withAnimation {
                                model.setPlayerState(tile)
                            }
                        }
                    }
                }
                .frame(width: 340)
                
                Spacer()
                
                ScoreView(model: model)
                    .frame(maxWidth: 200)
            }
            
            Text(model.messages)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .sheet(isPresented: $model.showGamePlay) {
            GamePlayView(game: gameData)
        }
        .frame(width: 560)
    }
    
    var topBarAndButtons: some View {
        HStack {
            Button(action: { model.showGamePlay.toggle() }) {
                Image(systemName: "questionmark.circle.fill")
            }
            .buttonStyle(.plain)
            .help("Show game rules")
            
            Spacer()

            Button(action: { model.resetGame() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
            }
            .buttonStyle(.plain)
            .help("Reset the game")

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
    TicTacToeView(gameData: Games().games.first(where: { $0.id == "ticTacToe" } )!)
}
