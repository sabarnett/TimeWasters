//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 20/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

enum GameState {
    case playing
    case gameOver
}

@Observable
class MatchedPairsGameModel {
    var tiles: [Tile] = []
    
    var columns: Int = 6       // Hard = 10, medium = 8, easy = 6
    var rows: Int = 4           // Hard = 6, medium = 5, easy = 4
    
    var gameState: GameState = .playing
    var cardBackground: String = "back_01"
    
    var moves: Int = 0
    var time: Int = 0
    
    init() {
        newGame()
    }
    
    /// Starts a new game, generating a new card deck and a new card background. It
    /// resets the score and the timer.
    func newGame() {
        tiles.removeAll(keepingCapacity: true)
        tiles = gameTiles()

        cardBackground = randomBackground()
        
        moves = 0
        time = 0
        
        gameState = .playing
    }
    
    /// Creates the tiles for a new game. Each tile will be generated with a card face
    /// name and will be initialised face fown. The number of tiles depends on the
    /// game board size. There will always be two tiles generated per card.
    ///
    /// - Returns: The array of tiles for this game.
    private func gameTiles() -> [Tile] {
        let cardNames: [String] = allPotentialCards()

        // 10x6 grid of tiles
        var tileSetup: [Tile] = []
        for i in 0..<(columns*rows)/2 {
            let tileOne = Tile(face: cardNames[i])
            tileSetup.append(tileOne)
            let tileTwo = Tile(face: cardNames[i])
            tileSetup.append(tileTwo)
        }
        
        return tileSetup.shuffled()
    }
    
    /// Generate a list of the names of all of the potential cards we could have in
    /// this game. Cards will have a suit name (heart, club, diamond, spade) an
    /// underscore and a two digit card value between 01 and 13 (ace thru
    /// jack, queen, king).
    ///
    /// - Returns: An array of all potential card names we could use in this game,
    /// shuffled into a random order.
    private func allPotentialCards() -> [String] {
        var cardNames: [String] = []
        
        for suit in ["heart", "club", "diamond", "spade"] {
            for value in 1..<13 {
                cardNames.append("\(suit)_\(String(format: "%02d", value))")
            }
        }
        
        return cardNames.shuffled()
    }
    
    /// We have face down card images numbered _01 thru _05. Generate the name of
    /// one of these card images for the new game.
    ///
    /// - Returns: The name of the 'face down' card image.
    private func randomBackground() -> String {
        let background = Int.random(in: 1...5)
        return "back_\(String(format: "%02d", background))"
    }
    
    /// Player selected a tile on the game board. Make sure the game is still playing and that
    /// the file exists (should never not exist) before toggling it to face up. If we currently have
    /// two cards face up, turn them doen - we cannot ever have more than two face up cards.
    ///
    /// - Parameter tile: The tile the player clicked on
    func select(_ tile: Tile) {
        guard gameState == .playing,
                tile.isMatched == false,
                tile.isFaceUp == false,
                let tileIndex = tiles.firstIndex(where: {$0.id == tile.id}) else { return }
        
        moves += 1
        turnCardsDownIfRequired()
        
        tiles[tileIndex].isFaceUp = true
        checkForMatch()
        checkForEndOfGame()
    }
    
    /// If the user has two cards face up and taps a third card, the previous
    /// two cards must be turned face down.
    private func turnCardsDownIfRequired() {
        let indexes = tiles.enumerated().compactMap { $1.isFaceUp ? $0 : nil }
        
        if indexes.count == 2 {
            // Turn existing cards face down
            for index in indexes {
                tiles[index].isFaceUp = false
            }
        }
    }
    
    /// Do we have two cards face up and, if we do, are they the same card?
    private func checkForMatch() {
        let indexes = tiles.enumerated().compactMap { $1.isFaceUp ? $0 : nil }
        if indexes.count != 2 { return }
        
        if tiles[indexes[0]].face != tiles[indexes[1]].face { return }
        
        // We have a match - update both cards
        tiles[indexes[0]].match()
        tiles[indexes[1]].match()
    }
    
    /// Check for the end of the game. That's when all cards are marked as matched
    private func checkForEndOfGame() {
        if tiles.allSatisfy({$0.isMatched}) {
            // Game over
            gameState = .gameOver
        }
    }
}
