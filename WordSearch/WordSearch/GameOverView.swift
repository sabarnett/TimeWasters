//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 04/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameOverView: View {
    var restart: () -> Void
    
    @State var timeExpired: Bool = false

    var caption: String {
        timeExpired ? "Time's Up!" : "You Win!"
    }
    var backgroundColor: Color {
        timeExpired ? .red.opacity(0.7) : .green.opacity(0.7)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text(caption)
                .textCase(.uppercase)
            .font(.system(size: 60).weight(.black))
            .fontDesign(.rounded)
            .foregroundStyle(.white)

            Button(action: restart) {
                Text("Play Again")
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
        .background(backgroundColor.gradient)
    }
}

#Preview {
    GameOverView(restart: {})
}
