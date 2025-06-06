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

struct GameBoardView: View {
    var game: WordSearchViewModel

    var body: some View {
        HStack(spacing: Constants.cellSpacing) {
            ForEach(0..<game.gameBoard.count, id: \.self) { i in
                VStack(spacing: Constants.cellSpacing) {
                    let column = game.gameBoard[i]
                    
                    ForEach(column) { letter in
                            TileView(tile: letter)
                            .onTapGesture {
                                game.select(letter: letter)
                            }
                        }
                    }
                }
            }
    }
}
