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
import AdventureGame
import NumberCombinations
import TicTacToe
import Othello

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
        
        /// Minesweeper Game - opening window
        WindowGroup(id: "minesweeper", for: Game.self) { $game in
            MinesweeperView(gameData: gameList.game(for: "minesweeper")!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        /// Word Craft Game - opening window
        WindowGroup(id: "wordcraft", for: Game.self) { $game in
            WordCraftView(gameData: gameList.game(for: "wordcraft")!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        /// Snake Game - opening window
        WindowGroup(id: "snake", for: Game.self) { $game in
            SnakeGameView(gameData: gameList.game(for: "snake")!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        /// Pyramid of Doom Adventure Game - opening window
        WindowGroup(id: "pyramidOfDoom", for: Game.self) { $game in
            AdventureGameView(gameData: gameList.game(for: "pyramidOfDoom")!, game: "adv08")
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)
        
        /// Number Combinations Game - opening window
        WindowGroup(id: "numberCombinations", for: Game.self) { $game in
            CombinationsView(gameData: gameList.game(for: "numberCombinations")!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)

        WindowGroup(id: "ticTacToe", for: Game.self) { $game in
            TicTacToeView(gameData: gameList.game(for: "ticTacToe")!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)

        WindowGroup(id: "othello", for: Game.self) { $game in
            OthelloView(gameData: gameList.game(for: "othello")!)
        }
        .defaultPosition(.center)
        .windowResizability(.contentSize)

        Settings {
            SettingsView()
        }
    }
    
    /// Called to change the display mode for the entire app when it gets changed in the settings
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
