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
import SharedComponents

public struct WordSearchView: View {
    @State private var gameData: Game

    @State private var game: WordSearchViewModel = .init()
    
    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    var viewWidth: CGFloat {
        (Constants.tileSize + 2) * CGFloat(Constants.tileCountPerRow)
        + Constants.wordListWidth
        + 32.0
    }
    
    public var body: some View {
        VStack {
            Button("Toolbar") { }

            HStack(spacing: 8) {
                ZStack {
                    GameBoardView(game: game)
                    MatchedWordsView(game: game)
                }
                
                List {
                    ForEach(game.words, id: \.id) { word in
                        Text(word.word)
                            .font(.system(size: 18))
                            .strikethrough(word.found)
                    }
                    .listRowSeparator(.hidden)
                }
                .frame(width: Constants.wordListWidth)
                .padding(.vertical)
                
            }

            Button("Status bar") { }
        }
        .frame(width: viewWidth)
    }
}

#Preview {
    WordSearchView(gameData: Games().games.first(where: {$0.id == "wordSearch"})!)
}
