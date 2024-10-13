//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 21/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct GameInfo: View {
    
    @Environment(\.dismiss) private var dismiss
    var gameData: Game
    
    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(gameData.title).font(.title)
            Text(gameData.tagLine).font(.subheadline)
            ScrollView {
                Text(gameData.description)
            }
            .padding(6)
            .border(.black, width: 0.5)
            
            Text(gameData.credits)
            HStack {
                Text(gameData.link)
                Spacer()
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Text("Close") })
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
            }
        }
        .frame(width: 500, height: 300, alignment: .leading)
        .padding()
    }
}

#Preview {
    GameInfo(gameData: Game(id: "Test", title: "Sample", tagLine: "This is a sample game", description: "This is the description of the game", credits: "Credit the author", link: "Link to web site"))
}
