//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 18/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//


import SwiftUI

public struct GameOverView: View {
    public var restart: () -> Void
    public var message: String
    public var playAgain: String
    
    public init(message: String = "Game Over",
                buttonCaption: String = "Play Again",
                restart: @escaping () -> Void) {
        self.restart = restart
        self.message = message
        self.playAgain = buttonCaption
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            Text(message)
                .textCase(.uppercase)
            .font(.system(size: 60).weight(.black))
            .fontDesign(.rounded)
            .foregroundStyle(.white)

            Button(action: restart) {
                Text(playAgain)
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
    GameOverView(restart: {})
}
