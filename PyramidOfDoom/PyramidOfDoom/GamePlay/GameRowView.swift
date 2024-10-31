//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 28/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameRowView: View {
    
    var gameDataRow: GameDataRow
    var alignment: HorizontalAlignment {
        gameDataRow.dataType == .consoleOutput ? .leading : .trailing
    }
    
    var body: some View {
        if gameDataRow.dataType == .consoleOutput {
            HStack {
                Text(gameDataRow.text)
                    .font(.system(size: 16))
                    .padding(5)
                Spacer()
            }
        } else {
            HStack {
                Spacer()
                Text(gameDataRow.text)
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.accentColor.opacity(0.6))
                    })
                }
        }
     }
}
                                
#Preview {
    GameRowView(gameDataRow: GameDataRow(message: "Hello, World!", type: .consoleOutput))
}
