//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 22/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct MatchedPairsSettingsView: View {
    
    @AppStorage(Constants.playSound) private var playSounds = true
    @AppStorage(Constants.gameDifficulty) private var gameDifficulty: GameDifficulty = .easy

    public init() { }
    
    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $playSounds)
            
            Picker("Game difficulty", selection: $gameDifficulty) {
                ForEach(GameDifficulty.allCases) { difficulty in
                    Text(difficulty.description)
                        .tag(difficulty)
                }
            }
        }
        .frame(width: 350)
        .padding()
    }

}

#Preview {
    MatchedPairsSettingsView()
}
