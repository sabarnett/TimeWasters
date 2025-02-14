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

    @AppStorage(Constants.autoFlip) private var autoFlip: Bool = false
    @AppStorage(Constants.autoFlipDelay) private var autoFlipDelay: Double = 5

    @State var beginCountdown: Bool = false
    @State var countdownRed: Color = Color.clear
    @State var countdownBlack: Color = Color.clear
    
    let myBundle = Bundle(for: MatchedPairsGameModel.self)
    var tile: Tile
    var onTap: (() -> Void)
    
    var body: some View {
        ZStack {
            cardFaceDownButton
            cardFaceUpButton
        }
        .onChange(of: tile.isFaceUp) { _, newValue in
            if newValue == true && autoFlip {
                withAnimation(.linear(duration: autoFlipDelay)) {
                    startCountdown()
                } completion: {
                    withAnimation {
                        stopCountdown()
                        model.turnFaceDown(tile)
                    }
                }
            } else if beginCountdown {
                stopCountdown()
            }
        }
    }
    
    var cardFaceDownButton: some View {
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
                    .shadow(color: Color(red: 0.50, green: 0.50, blue: 0.50),
                                           radius: 10.00, x: 5.00, y: 5.00)
            } else {
                Image(model.cardBackground, bundle: myBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                
                    .rotation3DEffect(.degrees(tile.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isFaceUp ? 0 : 1)
                    .accessibility(hidden: tile.isFaceUp)
                    .shadow(color: Color(red: 0.50, green: 0.50, blue: 0.50),
                                           radius: 10.00, x: 5.00, y: 5.00)
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    var cardFaceUpButton: some View {
        Button(action: {
            onTap()
        }, label: {
            ZStack {
                Image(tile.face, bundle: myBundle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                    .rotation3DEffect(.degrees(tile.isFaceUp ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isFaceUp ? 1 : -1)
                    .accessibility(hidden: !tile.isFaceUp)
                    .shadow(color: Color(red: 0.50, green: 0.50, blue: 0.50),
                                           radius: 10.00, x: 5.00, y: 5.00)

                if autoFlip {
                    countdownBar
                }
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    var countdownBar: some View {
        HStack {
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(countdownRed)
                    .frame(width: 60 , height: 8, alignment: .leading)
                Rectangle()
                    .fill(countdownBlack)
                    .frame(width: beginCountdown ? 0 : 60 , height: 8, alignment: .leading)
            }.offset(y: 45)
        }
    }
    
    func startCountdown() {
        countdownRed = .red
        countdownBlack = .black
        beginCountdown = true
    }
    
    func stopCountdown() {
        countdownRed = .clear
        countdownBlack = .clear
        beginCountdown = false
    }
}

#Preview {
    TileView(tile: Tile(face: "diamond_01")) {}
//    TileView(tile: .constant(Tile(face: "diamond_01"))) {}
}
