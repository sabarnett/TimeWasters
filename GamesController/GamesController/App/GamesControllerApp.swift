//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 09/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents
import MineSweeper
import WordCraft

@main
struct GamesControllerApp: App {
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .auto
    @State var gameList = Games()
    
    var body: some Scene {
        WindowGroup {
            GameIndexView()
                .environmentObject(gameList)
                .onAppear { setDisplayMode() }
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .commands { Menus() }
        .onChange(of: displayMode) { setDisplayMode() }
        
        WindowGroup(id: "minesweeper", for: Game.self) { $game in
            MinesweeperView(gameData: game!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "wordcraft", for: Game.self) { $game in
            WordCraftView(gameData: game!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "game1", for: Game.self) { $game in
            Text(game!.description)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "game2", for: Game.self) { $game in
            Text(game!.description)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "game3", for: Game.self) { $game in
            Text(game!.description)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        Settings {
            SettingsView()
        }
    }
    
    fileprivate func setDisplayMode() {
        switch displayMode {
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .auto:
            NSApp.appearance = nil
        }
    }
}
