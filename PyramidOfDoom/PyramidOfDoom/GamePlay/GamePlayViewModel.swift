//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class GamePlayViewModel {
    
    var gameDefinition: GameDefinition
    var game: AdventureGame
    var gameProgress = [GameDataRow]()
    var commandLine: String = ""
    var showGamePlay: Bool = false
    
    init(game gameName: String) {
        let gamesList = GameDefinitions()
        self.gameDefinition = gamesList.game(forKey: gameName)!

        var optionSet = GameOptions()
        optionSet.BugTolerant = true

        game = AdventureGame(withOptions: optionSet)
        loadGame(fromFile: gameDefinition.file)
        
        game.DisplayText = ShowGameText
        game.DisplayPrompt = ShowPrompt
        game.initiliseGame()
        game.promptForTurn()        
    }
    
    var carriedItems: [String] {
        game.CarriedItems
    }
    var treasureItems: [String] {
        game.Treasures
    }
    var treasuresFound: Int {
        game.TreasuresFound
    }
    
    /// Clear all game state and start the game again
    func restartGame() {
        gameProgress.removeAll()
        
        var optionSet = GameOptions()
        optionSet.BugTolerant = true

        game = AdventureGame(withOptions: optionSet)
        loadGame(fromFile: gameDefinition.file)
        
        game.DisplayText = ShowGameText
        game.DisplayPrompt = ShowPrompt
        game.initiliseGame()
        game.promptForTurn()
    }
    
    /// Save the current state of the game so it can be restored later
    func saveGame() {
        let gameSaver = GameSave()
        gameSaver.save(game: game, progress: gameProgress, gameDefinition: gameDefinition)
    }
    
    /// Clear the current state of the game and reload the last saved game details.
    func restoreGame() {
        let gameLoader = GameSave()
        gameLoader.restore(game: &game, progress: &gameProgress, gameDefinition: gameDefinition)
    }
    
    /// Displays the text from the game.
    ///
    /// - Parameter message: The game generated message to display.
    private func ShowGameText(message: String) {
        gameProgress.append(GameDataRow(message: message, type: .consoleOutput))
    }

    /// Sets the prompt text
    ///
    /// - Parameter message: The game generated prompt.
    private func ShowPrompt(message: String) {
        commandLine = ""
    }
    
    func consoleEnter() {
        let userInput = commandLine.trimmingCharacters(in: .whitespacesAndNewlines)
        if userInput.isEmpty { return }
        
        gameProgress.append(GameDataRow(message: userInput, type: .userInput))
        game.processTurn(command: userInput)
        
        commandLine = ""
    }
    
    private func loadGame(fromFile: String) {
        let bundle = Bundle(for: GamePlayViewModel.self)
        let fileUrl = bundle.url(forResource: fromFile, withExtension: "dat")

        if let jsFile = fileUrl {
            do {
                let gameData = try String(contentsOf: jsFile, encoding: .utf8)
                game.loadGame(fromData: gameData)
            } catch {
                print(error)
            }
        }

    }
}