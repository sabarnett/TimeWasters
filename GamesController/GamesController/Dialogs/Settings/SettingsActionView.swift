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
import MineSweeper
import WordCraft
import Snake
import NumberCombinations

struct SettingsActionView: View {
    @Binding var selectedOption: SettingsTabs
    
    var body: some View {
        switch selectedOption {
        case .general:
            GeneralSettingsView()
                .settingsViewDefinition(title: "General settings",
                                        icon: "gearshape")
            
        case .minesweeper:
            MinesweeperSettings()
                .settingsViewDefinition(
                    title: "Minesweeper settings",
                    icon: "square.and.arrow.up")
            
        case .wordcraft:
            WordCraftSettingsView()
                .settingsViewDefinition(title: "Word Craft settings",
                                        icon: "textformat.abc")
            
        case .snake:
            SnakeSettingsView()
                .settingsViewDefinition(title: "Snake settings",
                                        icon: "scribble.variable")
        
        case .numbercombinations:
            CombinationsSettingsView()
                .settingsViewDefinition(
                    title: "Number Combinations settings",
                    icon: "squareshape.split.2x2.dotted")
        }
    }
}
