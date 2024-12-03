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
    @Published var playersGo: Bool = true

    @Published var showGamePlay: Bool = false
    
    private var notify = PopupNotificationCentre.shared

    init() {
        initialiseGameBoard()
    }
    
    /// Accept the players move
    ///
    /// - Parameter tile: The tile the player tapped on.
    ///
    /// The player tapped on a tile. We need to first check that the tile is empty (which
    /// it should be because used tiles are disabled) and we need to check that ity's the
    /// players turn (belt and braces check to ensure we don't get two taps).
    ///
    /// Once we have the tap, we flip the playersGo flag to stop tyhe player tapping a
    /// second tile. We then set the selected tile to the player state and check whether
    /// the game has been won.
    ///
    /// Assuming it hasn't, we tell the user that it's the computers turn and drop out.
    ///
    func setPlayerState(_ tile: PuzzleTile) -> Bool {
        guard tile.state == .empty else { return false }
        guard playersGo else { return false }
        
        playersGo.toggle()
        objectWillChange.send()

        tile.state = .player
        checkForWin(.player)
        
        messages = "My turn... thinking..."
        return true
    }
    
    /// Calculate the computers go.
    ///
    /// We can do fewer checks here as we know this code will only be called when
    /// it is the computers turn. We use a simple algorithm to calculate the tile that
    /// the computer wants to play and we set that tile state.
    ///
    /// Once the state has been set, we check for a win or a draw. If no one has won
    /// or there is no draw, we set the flag to indicate the players go, let the player know
    /// it's their turn and drop out.
    ///
    func setComputerState() {
        let computersGo = computerTry()
        gameBoard[computersGo].state = .computer
        
        checkForWin(.computer)
        playersGo.toggle()
        messages = "Your turn..."
    }
    
    /// Reset the game - clear the board, clear scores
    func resetGame() {
        initialiseGameBoard()
        
        playerWins = 0
        computerWins = 0
        draws = 0
        
        notify.showPopup(.success,
            title: "Game Reset",
            description: "The game has been reset")

        if Int.random(in: 0...10) <= 3 {
            // Computer goes first.
            playersGo = false
            setComputerState()
        } else {
            playersGo = true
        }
    }
    
    private func checkForWin(_ winner: TileState) {
        if isWinner(winner) {
            print("\(winner) Won")
        }
    }
    
    /// The game board is a 3x3 array of tiles. To keep the code uncomplocated, we
    /// keep these tiles in a single dimension array of 9 tiles.
    private func initialiseGameBoard() {
        gameBoard = []
        for _ in 0..<9 {
            gameBoard.append(PuzzleTile(state: .empty))
        }
    }
}

extension TicTacToeGameModel {
    
    /**
     1. See if there’s a move the computer can make that will win the game. If there is, take that move. Otherwise, go to step 2.

     2. See if there’s a move the player can make that will cause the computer to lose the game. If there is, the computer should move there to block the player. Otherwise, go to step 3.

     3. Check if any of the corners (spaces 1, 3, 7, or 9) are free. If no corner space is free, go to step 4.

     4. Check if the center is free. If so, move there. If it isn’t, go to step 5.

     5. Move on any of the sides (spaces 2, 4, 6, or 8). There are no more steps, because the side spaces are the only spaces left if the execution has reached this step.

     The function will return an integer from 1 to 9 representing the computer’s move.
     */
    private func computerTry() -> Int {
        if let move = computerWinningMove() { return move }
        if let move = playerWinningMove() { return move }
        if let move = checkCorners() { return move }
        if let move = checkCenter() { return move }
        if let move = checkSides() { return move }
        return 0
    }

    /// 1. See if there’s a move the computer can make that will win the
    /// game. If there is, take that move. Otherwise, go to step 2.
    private func computerWinningMove() -> Int? {
        if let move = checkCells(topRow, state: .computer) { return move }
        if let move = checkCells(middleRow, state: .computer) { return move }
        if let move = checkCells(bottomRow, state: .computer) { return move }
        if let move = checkCells(columnOne, state: .computer) { return move }
        if let move = checkCells(columnTwo, state: .computer) { return move }
        if let move = checkCells(columnThree, state: .computer) { return move }
        if let move = checkCells(leftDiagonal, state: .computer) { return move }
        if let move = checkCells(rightDiagonal, state: .computer) { return move }

        // No winning move
        return nil
    }
    
    /// 2. See if there’s a move the player can make that will cause the computer
    /// to lose the game. If there is, the computer should move there to block the
    /// player. Otherwise, go to step 3.
    private func playerWinningMove() -> Int? {
        if let move = checkCells(topRow, state: .player) { return move }
        if let move = checkCells(middleRow, state: .player) { return move }
        if let move = checkCells(bottomRow, state: .player) { return move }
        if let move = checkCells(columnOne, state: .player) { return move }
        if let move = checkCells(columnTwo, state: .player) { return move }
        if let move = checkCells(columnThree, state: .player) { return move }
        if let move = checkCells(leftDiagonal, state: .player) { return move }
        if let move = checkCells(rightDiagonal, state: .player) { return move }

        // No winning move
        return nil

    }
    
    /// 3. Check if any of the corners (spaces 1, 3, 7, or 9) are free. If no
    /// corner space is free, go to step 4.
    private func checkCorners() -> Int? {
        if let cell = corners.filter({ $0.state == .empty }).randomElement() {
            return gameBoard.firstIndex(where: {$0.id == cell.id })
        }
        return nil
    }
    
    /// 4. Check if the center is free. If so, move there. If it isn’t, go to step 5.
    private func checkCenter() -> Int? {
        if gameBoard[4].state == .empty { return 4 }
        return nil
    }
    
    /// 5. Move on any of the sides (spaces 2, 4, 6, or 8). There are no more
    /// steps, because the side spaces are the only spaces left if the execution
    /// has reached this step.
    private func checkSides() -> Int? {
        if let cell = sides.filter({ $0.state == .empty }).randomElement() {
            return gameBoard.firstIndex(where: {$0.id == cell.id })
        }
        return nil
    }
    
    private func checkCells(_ cells: [PuzzleTile], state: TileState) -> Int? {
        if cells.filter({ $0.state == state }).count == 2
        && cells.filter({ $0.state == .empty }).count == 1 {
            let cell = cells.filter({ $0.state == .empty }).first
            return gameBoard.firstIndex(where: {$0.id == cell!.id })
        }
        
        return nil
    }
}
 
extension TicTacToeGameModel {

    // Winning moves
    // Top row      [0,1,2]
    // Middle row   [3,4,5]
    // Bottom row   [6,7,8]
    // Column 1     [0,3,6]
    // Column 2     [1,4,7]
    // Column 3     [2,5,8]
    // Right diag   [0,4,8]
    // Left diag    [2,4,6]
    var topRow: [PuzzleTile] { [ gameBoard[0], gameBoard[1], gameBoard[2] ] }
    var middleRow: [PuzzleTile] { [ gameBoard[3], gameBoard[4], gameBoard[5] ] }
    var bottomRow: [PuzzleTile] { [ gameBoard[6], gameBoard[7], gameBoard[8] ] }
    
    var columnOne: [PuzzleTile] { [ gameBoard[0], gameBoard[3], gameBoard[6] ] }
    var columnTwo: [PuzzleTile] { [ gameBoard[1], gameBoard[4], gameBoard[7] ] }
    var columnThree: [PuzzleTile] { [ gameBoard[2], gameBoard[5], gameBoard[8] ] }
    
    var rightDiagonal: [PuzzleTile] { [ gameBoard[0], gameBoard[4], gameBoard[8] ] }
    var leftDiagonal: [PuzzleTile] { [ gameBoard[2], gameBoard[4], gameBoard[6] ] }
    
    // Corner Cells
    var corners: [PuzzleTile] { [ gameBoard[0], gameBoard[2], gameBoard[6], gameBoard[8]] }
    var sides: [PuzzleTile] { [ gameBoard[1], gameBoard[3], gameBoard[5], gameBoard[7]] }
    
    func isWinner(_ player: TileState) -> Bool {
        return topRow.allSatisfy({ $0.state == player})
        || middleRow.allSatisfy({ $0.state == player})
        || bottomRow.allSatisfy({ $0.state == player})
        || columnOne.allSatisfy({ $0.state == player})
        || columnTwo.allSatisfy({ $0.state == player})
        || columnThree.allSatisfy({ $0.state == player})
        || rightDiagonal.allSatisfy({ $0.state == player})
        || leftDiagonal.allSatisfy({ $0.state == player})

    }
}
