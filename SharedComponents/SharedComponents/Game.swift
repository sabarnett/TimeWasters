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
            snakeGame(),
            pyramidOfDoom()
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
                "To win a game of Minesweeper, all non-mine cells must be opened without opening a mine. There is no score, but there is a timer recording the time taken to finish the game. Difficulty can be increased by adding mines or starting with a larger grid. You can do this via the settings panel. Beginner level is usually on an 8x8 or 9x9 board containing 10 mines, Intermediate is usually on a 16x16 board with 40 mines and expert is usually on a 22x22 board with 99 mines; however, you are free to customize board size and mine count."
             ),
             gamePlay: textBlock(
                "When the game starts you will be presented with a grid. Under that grid are hidden a number of mines. It is your job to locate those mines and to clear every cell without a mine.",
                "You select a cell by clicking on it. If the cell does not contain a mine, it will clear and surrounding cells will be updated to show how many cells border it. This is your only clue to the whereabouts of mined cells.",
                "You can indicate that you believe a cell to contain a mine by long-pressing on it. When you do this a warning symbol will be placed on the cell. There is no guarantee that the cell actually contains a mine, so beware! If you change your mind, long-press to remove the marker.",
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
             description: textBlock(
                "WordCraft is a game where you have to use a limited number of letters to create a word. To make the game more challenging, you will be given a challenge to meet, such as a word with a specific number of letters or a word that starts with a specific letter.",
                "There is no time limit to complete the challenge, but you must meet the challenge and you cannot use the same work more than once.",
                "Letters you use to successfully create a word will be removed from the game board and replaced with a random set of replacement letters."
                                    ),
             gamePlay: textBlock(
                "You can select specific letters by click on them in the grid. To submit your word for testing, you click the same letter twice. This will validate that the challenge has been met, that the word has not been used before and that it is in the games dictionary. If these are all met, the letters will be removed from the game and replacements generated.",
                "If you click on a previously selected letter, it will become the last letter and any letters selected after it will be removed from your word. This gives you a quick way to remove multiple letters.",
                "All words must be three or more letters.",
                "As an alternative, you can use the  keyboard to select letters. If you do this, the game will randomly select a tile for you. Pressing return will submit your word for testing and backspace will remove letters from the word."),
             credits: "Paul Hudson - Hacking With Swift+",
             link: "https://www.hackingwithswift.com/plus")
    }
    
    private func snakeGame() -> Game {
        Game(id: "snake",
             title: "Snake Game",
             tagLine: "Feed the snake, but beware the borders",
             description: textBlock(
                "This is a classic game from the early days of computing. The premise is very simple but game play is surprisingly difficult the longer you play. ",
                "Your job is to guide the snake towards it's food. The snake will grow longer as it eats food. If it touches the borders or itself, it will die. As the game progresses and the snake grows longer and longer, you will need to work out routes to the food that will not cause the snake to die.",
                "The game is very addictive and can be played for hours. It is a great way to spend a few minutes."
             ),
             gamePlay: textBlock(
                "The snake is controlled using the arrow keys on the keyboard. You can also pause play by pressing the space bar. When you are ready to resume, press space again."
             ),
             credits: "Steve Barnett",
             link: "http://www.sabarnett.co.uk")
    }
    
    private func pyramidOfDoom() -> Game {
        Game(id: "pyramidOfDoom",
             title: "Pyramid of Doom",
             tagLine: "Can you survive the pyramid of doom?",
             description: textBlock(
                "This is a text adventure where you will explore the Pyramid Of Doom, looking for teasures to store in the treasure room all while trying to avoid the traps that are there to stop you.",
                "Your mission is simple, find al the treasures before the pyramid kills you.",
                "You are going to navigate from location to location using text commands like 'north', 'south', 'east', 'west', 'take item', 'drop item', 'read', 'inventory' and 'help'. There are many more commands, just try them out!"
                ),
             gamePlay: textBlock(
                "You can see where you are at any time by typing 'look'. That will show you your current location, what's at that location and possible directions you can go in. You can also take items by typing 'take item'. You can drop items by typing 'drop item'. You can read items by typing 'read item'. You can see your inventory by typing 'inventory'. You can also ask for help by typing 'help'."
             ),
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
