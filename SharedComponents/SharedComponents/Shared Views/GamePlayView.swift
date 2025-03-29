//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 08/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct GamePlayView: View {
    @Environment(\.dismiss) private var dismiss
    
    private var gameData: Game
    
    public init(game: Game) {
        self.gameData = game
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(gameData.title).font(.title)
            Text(gameData.tagLine).font(.subheadline)
            ScrollView {
                Text(gameData.gamePlay)
            }
            .padding(6)
            .border(.black, width: 0.5)

            HStack {
                Spacer()
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Text("Close") })
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .padding(.horizontal, 8)
            }
        }
        .frame(width: 500, height: 300, alignment: .leading)
        .padding()
    }
}

#Preview {
    GamePlayView(game: Games().games.first!)
}
