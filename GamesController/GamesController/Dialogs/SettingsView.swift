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

enum SettingsTabs {
    case general
    case minesweeper
    case wordcraft
    case snake
    case numbercombinations
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

struct SettingsSelectionView: View {
    @Binding var selectedOption: SettingsTabs
    
    var body: some View {
        List(selection: $selectedOption) {
            Label("General", systemImage: "gearshape")
                .tag(SettingsTabs.general)
            Label("Minesweeper", systemImage: "square.and.arrow.up")
                .tag(SettingsTabs.minesweeper)
            Label("WordCraft", systemImage: "textformat.abc")
                .tag(SettingsTabs.wordcraft)
            Label("Snake", systemImage: "scribble.variable")
                .tag(SettingsTabs.snake)
            Label("Combinations", systemImage: "squareshape.split.2x2.dotted")
                .tag(SettingsTabs.numbercombinations)
        }
    }
}

struct SettingsActionView: View {
    @Binding var selectedOption: SettingsTabs
    
    var body: some View {
        switch selectedOption {
        case .general:
            ScrollView {
                SettingsTitle(systemImage: "gearshape", title: "General settings")
                GeneralSettingsView()
            }
        case .minesweeper:
            ScrollView {
                SettingsTitle(systemImage: "square.and.arrow.up", title: "Minesweeper settings")
                MinesweeperSettings()
            }
        case .wordcraft:
            ScrollView {
                SettingsTitle(systemImage: "textformat.abc", title: "Word Craft settings")
                WordCraftSettingsView()
            }
        case .snake:
            ScrollView {
                SettingsTitle(systemImage: "scribble.variable", title: "Snake settings")
                SnakeSettingsView()
            }
        case .numbercombinations:
            ScrollView {
                SettingsTitle(systemImage: "squareshape.split.2x2.dotted", title: "Number Combinations settings")
                CombinationsSettingsView()
            }
        }
    }
}

struct SettingsTitle: View {
    
    var systemImage: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                
            Text(title)
            Spacer()
        }
        .font(.title)
        .padding()
        .foregroundStyle(Color.accentColor)

    }
}

#Preview {
    SettingsView()
}
