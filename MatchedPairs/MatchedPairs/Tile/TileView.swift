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

struct TileView: View {
    
    @Environment(MatchedPairsGameModel.self) var model
    
    let myBundle = Bundle(for: MatchedPairsGameModel.self)
    var tile: Tile
    var onTap: (() -> Void)
    
    var body: some View {
        ZStack {
            Button(action: {
                if !tile.isMatched {
                    onTap()
                }
            }, label: {
                if tile.isMatched {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 35))
                        .frame(width: 80, height: 70)
                } else {
                    Image(tile.isMatched ? tile.face : model.cardBackground, bundle: myBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)

                        .rotation3DEffect(.degrees(tile.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(tile.isFaceUp ? 0 : 1)
                        .accessibility(hidden: tile.isFaceUp)
                }
            })
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                onTap()
            }, label: {
                Image(tile.face, bundle: myBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                    .rotation3DEffect(.degrees(tile.isFaceUp ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isFaceUp ? 1 : -1)
                    .accessibility(hidden: !tile.isFaceUp)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    TileView(tile: Tile(face: "diamond_01")) {}
//    TileView(tile: .constant(Tile(face: "diamond_01"))) {}
}
