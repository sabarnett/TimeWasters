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
    
    var gamePlayColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(80.00), spacing: 3), count: model.columns)
    }
    
    public init(gameData: Game) {
        self.gameData = gameData
        self.model = MatchedPairsGameModel()
    }
    
    public var body: some View {
        VStack {
            LazyVGrid(columns: gamePlayColumns) {
                ForEach(model.tiles) { tile in
                    TileView(tile: tile) {
                        withAnimation {
                            model.select(tile)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            model.newGame()
        }
    }
}

#Preview {
    MatchedPairsView(gameData: Games().games.first(where: { $0.id == "matchedPairs" } )!)
}
