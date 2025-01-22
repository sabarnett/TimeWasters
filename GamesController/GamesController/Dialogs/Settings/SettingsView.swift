//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 10/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum SettingsTabs {
    case general
    case minesweeper
    case wordcraft
    case snake
    case numbercombinations
    case matchedPairs
}

struct SettingsView: View {
    
    @State private var selectedOption: SettingsTabs = .general
    
    var body: some View {
        HStack {
            SettingsSelectionView(selectedOption: $selectedOption)
                .frame(width: 190)
            SettingsActionView(selectedOption: $selectedOption)
        }
        .frame(width: 740)
        .navigationTitle("Timewaster Settings")
        .navigationSplitViewStyle(.balanced)
        .frame(width: 740)
    }
}

#Preview {
    SettingsView()
}
