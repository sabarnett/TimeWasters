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

import Foundation
import Combine

public struct Game: Identifiable, CustomStringConvertible, Codable, Hashable {
    public var id: String
    public var title: String
    public var tagLine: String
    public var description: String = ""
    public var gamePlay: String = ""
    public var credits: String = ""
    public var link: String = ""
}

public class Games: ObservableObject {
    
    public private(set) var games: [Game] = []
    
    public init() {
        games = [
            minesweeperGame(),
            wordcraftGame(),
            snakeGame()
        ]
    }
    
    /// Return the game definition for the game with the passed in id.
    ///
    /// - Parameter id: The id of the game you want to retrieve
    ///
    /// - Returns: The Game definition for the game or nil if there is
    /// no game with the padded in id.
    public func game(for id: String) -> Game? {
        if let index = games.firstIndex(where: { $0.id == id }) {
            return games[index]
        } else {
            return nil
        }
    }
    
    private func minesweeperGame() -> Game {
        Game(id: "minesweeper",
        title: "Minesweeper",
        tagLine: "Can you clear the mines?",
             description: textBlock(
                "Minesweeper is a classic game from the dim and distant past. The aim of the game is to identify all of the mines without clicking on one and setting it off.",
                "Minesweeper rules are very simple. The board is divided into cells, with mines randomly distributed. To win, you need to open all the cells. The number on a cell shows the number of mines adjacent to it. Using this information, you can determine cells that are safe, and cells that contain mines. Cells suspected of being mines can be marked with a flag.",
                "To win a game of Minesweeper, all non-mine cells must be opened without opening a mine. There is no score, but there is a timer recording the time taken to finish the game. Difficulty can be increased by adding mines or starting with a larger grid. You can do this via the settings panel. Beginner level is usually on an 8x8 or 9x9 board containing 10 mines, Intermediate is usually on a 16x16 board with 40 mines and expert is usually on a 22x22 board with 99 mines; however, you are free to customise board size and mine count."
             ),
             gamePlay: textBlock(
                "When the game starts you will be presented with a grid. Under that grid are hidden a number of mines. It is your job to locate those mines and to clear every cell without a mine.",
                "You select a cell by clicking on it. If the cell does not contain a mine, it will clear and surrounding cells will be updated to show how many cells border it. This is your only clue to the whereabouts of mined cells.",
                "You can ndicate that you believe a cell to contain a mine by long-pressing on it. When you do this a warning symbol will be placed on the cell. There is no guarantee that the cell actually contains a mine, so beware! If you change your mind, long-press to remove the marker.",
                "The game ends when you either click on a mine or you clear all non-mine cells. If you clear all non-mine cells without opening a mine, you win!"
                                ),
        credits: "Paul Hudson - Hacking With Swift+, with modifications by Steven Barnett",
        link: "https://www.hackingwithswift.com/plus"
             )
    }
    
    private func wordcraftGame() -> Game {
        Game(id: "wordcraft",
             title: "Word Craft",
             tagLine: "Can you beat the word challenges?",
             description: "",
             gamePlay: textBlock(""),
             credits: "Paul Hudson - Hacking With Swift+",
             link: "https://www.hackingwithswift.com/plus")
    }
    
    private func snakeGame() -> Game {
        Game(id: "snake",
             title: "Snake Game",
             tagLine: "Feed the snake, but beware the borders",
             description: "",
             gamePlay: textBlock(""),
             credits: "Steve Barnett",
             link: "http://www.sabarnett.co.uk")
    }

    /// textBlock - takes a variadic parameter list of strings and returns a
    /// single string with each parameter separated by two newline characters.
    ///
    /// Used to make it easier and more readable to create the description text
    /// for a game.
    private func textBlock(_ text: String...) -> String {
        text.joined(separator: "\n\n")
    }
}
