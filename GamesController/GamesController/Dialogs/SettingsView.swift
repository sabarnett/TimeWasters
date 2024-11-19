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
import MineSweeper
import WordCraft
import Snake
import NumberCombinations

struct SettingsView: View {

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            MinesweeperSettings()
                .tabItem {
                    Label("Minesweeper", systemImage: "square.and.arrow.up")
                }
            
            WordCraftSettingsView()
                .tabItem {
                    Label("WordCraft", systemImage: "textformat.abc")
                }
            
            SnakeSettingsView()
                .tabItem {
                    Label("Snake", systemImage: "scribble.variable")
                }
            
            CombinationsSettingsView()
                .tabItem {
                    Label("Combinations", systemImage: "squareshape.split.2x2.dotted")
                }
        }
        .frame(minWidth: 460)
    }
}

#Preview {
    SettingsView()
}
