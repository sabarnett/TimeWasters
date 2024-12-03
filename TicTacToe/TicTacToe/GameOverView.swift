//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 03/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameOverView: View {
    var state: GameState
    var restart: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Group {
                if state == .playerWin {
                    Text("You win!")
                } else if state == .computerWin {
                    Text("I win this time")
                } else {
                    Text("It's a draw!")
                }
            }
            .textCase(.uppercase)
            .font(.system(size: 60).weight(.black))
            .fontDesign(.rounded)
            .foregroundStyle(.white)

            Button(action: restart) {
                Text("New Game")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundStyle(.white)
                    .background(.blue.gradient)
                    .clipShape(.rect(cornerRadius: 10))
            }
            .font(.title)
            .buttonStyle(.plain)
        }
        .transition(.scale(scale: 2).combined(with: .opacity))
        .padding(.vertical)
        .padding(.bottom, 5)
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.55).gradient)
    }
}

#Preview {
    GameOverView(state: .playerWin, restart: {})
}
