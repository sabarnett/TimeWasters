//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 13/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct SettingsSelectionView: View {
    @Binding var selectedOption: SettingsTabs
    
    var body: some View {
        VStack {
            Image("clock-face")
                .resizable()
                .frame(width: 90, height: 90)
                .padding()
            Text("Time Wasters Compendium")
                .font(.caption)
                .lineLimit(2)
                .italic()
            List(selection: $selectedOption) {
                Label("General", systemImage: "gearshape")
                    .tag(SettingsTabs.general)
                Label("Minesweeper", systemImage: "square.and.arrow.up")
                    .tag(SettingsTabs.minesweeper)
                Label("WordCraft", systemImage: "textformat.abc")
                    .tag(SettingsTabs.wordcraft)
                Label("Snake", systemImage: "scribble.variable")
                    .tag(SettingsTabs.snake)
                Label("Number Combo", systemImage: "squareshape.split.2x2.dotted")
                    .tag(SettingsTabs.numbercombinations)
                Label("Matched Pairs", systemImage: "square.and.line.vertical.and.square")
                    .tag(SettingsTabs.matchedPairs)
            }
        }
    }
}
