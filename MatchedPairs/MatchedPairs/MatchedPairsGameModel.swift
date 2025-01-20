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
    
    init() {
        newGame()
    }
    
    func newGame() {
        tiles = []
        var cardNames: [String] = []
        
        for suit in ["heart", "club", "diamond", "spade"] {
            for value in 1..<13 {
                cardNames.append("\(suit)_\(String(format: "%02d", value))")
            }
        }
        cardNames.shuffle()
        
        // 10x6 grid of tiles
        var tileSetup: [Tile] = []
        for i in 0..<(columns*rows)/2 {
            let tile = Tile(face: cardNames[i])
            tileSetup.append(tile)
            let tileCopy = Tile(face: cardNames[i])
            tileSetup.append(tileCopy)
        }
        
        tiles = tileSetup.shuffled()
        gameState = .playing
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
