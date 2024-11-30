//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 27/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

class TicTacToeGameModel: ObservableObject {
    
    @Published var gameBoard: [PuzzleTile] = []
    @Published var playerWins = 0
    @Published var computerWins = 0
    @Published var draws = 0
    @Published var messages: String = "Your Move"
    
    @Published var showGamePlay: Bool = false
    
    private var notify = PopupNotificationCentre.shared

    init() {
        initialiseGameBoard()
    }
    
    func setPlayerState(_ tile: PuzzleTile) {
        guard tile.state == .empty else { return }
        
        objectWillChange.send()

        tile.state = .player
        playerWins += 1
    }
    
    func resetGame() {
        initialiseGameBoard()
        
        playerWins = 0
        computerWins = 0
        draws = 0
        
        notify.showPopup(.success,
            title: "Game Reset",
            description: "The game has been reset")
    }
    
    private func initialiseGameBoard() {
        // Game board is a 3x3 array of PuzzleTile arranged as a single array
        gameBoard = []
        for _ in 0..<9 {
            gameBoard.append(PuzzleTile(state: .empty))
        }
    }
}

enum TileState {
    case empty
    case player
    case computer
}

class PuzzleTile: Identifiable, ObservableObject {
    var id: UUID = UUID()
    @Published var state: TileState
    
    init(state: TileState) {
        self.state = state
    }
    
    var tileColour: Color {
        switch state {
        case .empty:
            return Color.blue
        case .player:
            return Color.green
        case .computer:
            return Color.cyan
        }
    }
    
    var tileImage: String {
        switch self.state {
        case .empty:
            " "
        case .player:
            "😀"
        case .computer:
            "🤖"
        }
    }
    
    var isEmpty: Bool {
        self.state == .empty
    }
    
    func setState(state: TileState) {
        self.state = state
        print("Changing state")
    }
}
