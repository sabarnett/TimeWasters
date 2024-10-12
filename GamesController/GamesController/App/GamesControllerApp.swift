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
import Snake

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
            MinesweeperView(gameData: Games().games.first(where: {$0.id == "minesweeper"} )!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "wordcraft", for: Game.self) { $game in
            WordCraftView(gameData: Games().games.first(where: { $0.id == "wordcraft" } )!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        WindowGroup(id: "snake", for: Game.self) { $game in
            SnakeGameView(gameData: Games().games.first(where: { $0.id == "snake" } )!)
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
