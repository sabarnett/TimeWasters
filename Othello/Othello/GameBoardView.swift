//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 22/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameBoardView: View {
    
    @ObservedObject var model: OthelloViewModel
    
    var body: some View {
            ForEach(0..<model.gameBoard.count, id: \.self) { i in
                let column = $model.gameBoard[i]
                
                VStack(spacing: 2) {
                    ForEach(column) { $tile in
                        TileView(tile: $tile) {
                            playersMove(tile)
                        }
                    }
                }
            }
    }
    
    private func playersMove(_ tile: Tile) {
        withAnimation {
            if model.select(tile: tile) {   
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.bouncy) {
                        model.computerMove()
                    }
                }
            }
        }
    }
}

#Preview {
    GameBoardView(model: OthelloViewModel())
}
