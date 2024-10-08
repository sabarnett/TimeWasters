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

struct SettingsView: View {
    @StateObject private var settings = SettingsViewModel()

    var body: some View {
        TabView {
            GeneralSettingsView(settings: settings)
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            MinesweeperSettings()
                .tabItem {
                    Label("Minesweeper", systemImage: "square.and.arrow.up")
                }
        }
        .frame(minWidth: 460)
    }
}


#Preview {
    SettingsView()
}
