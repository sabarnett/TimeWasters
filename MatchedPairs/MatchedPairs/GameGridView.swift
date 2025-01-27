//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 27/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameGridView: View {
    
    var model: MatchedPairsGameModel
    
    var gamePlayColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(80.00), spacing: 3), count: model.columns)
    }

    var body: some View {
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

    }
}

#Preview {
    GameGridView(model: MatchedPairsGameModel())
}
