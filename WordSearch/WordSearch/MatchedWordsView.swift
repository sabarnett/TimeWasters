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

struct MatchedWordsView: View {
    var game: WordSearchViewModel
    
    var body: some View {
        ZStack {
            ForEach(game.matchedWords) { matchedWord in
                Path { path in
                    path.move(to: startPoint(matchedWord))
                    path.addLine(to: endPoint(matchedWord))
                    
                    path = path.strokedPath(
                        .init(
                            lineWidth: 1.0,
                            lineCap: .round,
                            lineJoin: .round,
                            miterLimit: 3.00
                        )
                    )
                }
                .stroke(Constants.selectedLineColor,
                        lineWidth: Constants.selectedLineWidth,
                        antialiased: true)
                .allowsHitTesting(false)
            }
        }
    }
    
    /// Calculate the center point of the cell at the start of the selected word.
    /// - Parameter matchedWord: The selected word coordinates
    /// - Returns: A CGPoint representing the middle of the first cell in
    /// the selected word.
    func startPoint(_ matchedWord: MatchedWord) -> CGPoint {
        CGPoint(
            x: transX(x: matchedWord.startX),
            y: transY(y: matchedWord.startY)
        )
    }
    
    /// Calculate the center point of the cell at the end of the selected word
    /// - Parameter matchedWord: The selected word coordinates
    /// - Returns: A CGPoint representing the middle of the last cell in
    /// the selected word.
    func endPoint(_ matchedWord: MatchedWord) -> CGPoint {
        CGPoint(
            x: transX(x: matchedWord.endX),
            y: transY(y: matchedWord.endY)
        )
    }
    
    /// Given the column number, calculate the center of the cell
    /// - Parameter x: The column to translate
    /// - Returns: The X position of the middle of the cell
    ///
    /// We add 8 to the X position to account for the spacing of the ZStack it is
    /// contained in.
    func transX(x: Int) -> CGFloat {
        (Constants.tileSize + 2) * CGFloat(x) + 12
        + (Constants.tileSize / 2)
    }
    
    /// Given the row number, calculate the center of the cell
    /// - Parameter y: The row number to translate
    /// - Returns: The X position of the middle of the cell
    ///
    /// We add 16 to the Y position to account for the padding of the ZStack it is
    /// contained in.
    func transY(y: Int) -> CGFloat {
        ((Constants.tileSize + 2) * CGFloat(y)) + 16
        + (Constants.tileSize / 2)
    }
}

#Preview {
    MatchedWordsView(game: WordSearchViewModel())
}
