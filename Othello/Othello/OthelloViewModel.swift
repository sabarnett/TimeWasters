//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 18/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

enum GameState {
    case playerMove
    case computerMove
    case playerWin
    case computerWin
    case noValidMove
}

struct BoardLocation {
    let xPos: Int
    let yPos: Int
}

class OthelloViewModel: ObservableObject {
    
    typealias GameBoard = [[Tile]]
    
    let boardWidth = 8
    let boardHeight = 8
    
    @Published var gameBoard = GameBoard()
    @Published var playerScore = 0
    @Published var computerScore = 0
    @Published var statusMessage = " "
    @Published var gameState: GameState = .playerMove
    @Published var showGamePlay: Bool = false
    
    private var allTiles: [Tile] { gameBoard.flatMap({$0}) }
    
    init() {
        newGame()
    }
    
    /// Starts a new game. This involves creating a new game board, setting
    /// the initial board state where there are four tiles in the middle (2x player
    /// and 2x computer).
    ///
    /// Once we have a board, we randomly choose who goes first, with a bias
    /// towards the player rather than the computer.
    func newGame() {
        gameBoard = createBoard()
        
        gameBoard[3][3].state = .player
        gameBoard[3][4].state = .computer
        gameBoard[4][3].state = .computer
        gameBoard[4][4].state = .player

        // who goes first; player or computer?
        if Int.random(in: 0..<3) == 0 {
            computerMove()
        }
    }
    
    /// Player selected a tile, ensure the move is valid and flip the tile
    /// if it is.
    func select(tile selectedTile: Tile) -> Bool {
        guard gameState == .playerMove else { return false }
        guard selectedTile.state == .empty || selectedTile.state == .potentialPlayerMove else {
            statusMessage = "That tile is not empty, please try again."
            return false
        }
        
        gameState = .computerMove
        resetHints()
        
        objectWillChange.send()
        for col in 0..<boardWidth {
            for row in 0..<boardHeight {
                if gameBoard[col][row].id == selectedTile.id {
                    if !makeMove(board: gameBoard, tileState: .player, xPos: col, yPos: row) {
                        statusMessage = "Invalid move, please try again."
                        gameState = .playerMove
                        return false
                    } else {
                        
                        let scores = getScores(board: gameBoard)
                        self.playerScore = scores.player
                        self.computerScore = scores.computer

                        statusMessage = "My move... thinking..."
                        return true
                    }
                }
            }
        }
        return false
    }
    
    /// Calculate the computers move. Assuming the computer can move, we place the
    /// computer tile, flip any that need flipping and update the scores.
    func computerMove() {
        
        guard let computer = getComputerMove() else {
            statusMessage = "I cannot move, you win..."
            // TODO: Present message to player
            return
        }
        makeMove(board: gameBoard, tileState: .computer, xPos: computer.xPos, yPos: computer.yPos)

        let scores = getScores(board: gameBoard)
        self.playerScore = scores.player
        self.computerScore = scores.computer
        
        // Can the player move?
        let boardCopy = getBoardCopy(gameBoard)
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .player)
        print("Possible moves: \(possibleMoves)")
        if possibleMoves.isEmpty {
            statusMessage = "You cannot move, game over..."
            // TODO: End the game
        }

        gameState = .playerMove
        statusMessage = "Your move..."
        
        // TODO: Check for end of game
    }
    
    /// Create an empty board. This is an array of arrays of Tile objects.
    private func createBoard() -> GameBoard {
        var board = GameBoard()
        
        for col in 0..<boardWidth {
            var row = [Tile]()
            for _ in 0..<boardHeight {
                row.append(Tile(column: col))
            }
            board.append(row)
        }

        return board
    }
    
    func showHint() {
        objectWillChange.send()
        markPlayerPotentialMoves()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.resetHints()
        }
    }
    
    private func resetHints() {
        let marked = allTiles.filter({$0.state == .potentialPlayerMove})
        if marked.count == 0 { return }
        
        objectWillChange.send()
        marked.forEach{$0.state = .empty}
    }

    /// Check that the move is valid. If it is, return a list of tile positions that need to
    /// be flipped to the new player state.
    private func isValidMove(board: GameBoard, tileState: TileState, xPos: Int, yPos: Int) -> [BoardLocation]? {
        
        guard board[xPos][yPos].state == .empty,
                isOnBoard(xPos: xPos, yPos: yPos) else { return nil }
        
        var tilesToFlip = [BoardLocation]()
        let flipState: TileState = tileState == .player ? .computer : .player
        
        // Array of the offsets from the current tile to scan.
        let scanDirections: [(Int, Int)] = [
            (1, 0), (0, 1), (-1, 0), (0, -1),
            (1, 1), (1, -1), (-1, 1), (-1, -1)
        ]
        
        scanDirections.forEach { (xDirection, yDirection) in
            var x = xPos + xDirection
            var y = yPos + yDirection
            
            while isOnBoard(xPos: x, yPos: y) && board[x][y].state == flipState {
                x += xDirection
                y += yDirection
                
                if isOnBoard(xPos: x, yPos: y) && board[x][y].state == tileState {
                    while true {
                        x -= xDirection
                        y -= yDirection
                        if x == xPos && y == yPos {
                            break
                        }
                        tilesToFlip.append(BoardLocation(xPos: x, yPos: y))
                    }
                }
            }
        }
        
        return tilesToFlip.count > 0 ? tilesToFlip : nil
    }
    
    /// Tests whether the position is on the game board or not
    /// - Parameters:
    ///   - xPos: The x position to test
    ///   - yPos: The y position to test
    /// - Returns: True if the position is valid else false.
    private func isOnBoard(xPos: Int, yPos: Int) -> Bool {
        return xPos >= 0 && xPos < boardWidth && yPos >= 0 && yPos < boardHeight
    }
    
    /// Using a copy of the current game board, determine what moves the player has
    /// and mark them as potential moves. The view can then be updated to highlight
    /// those moves.
    private func markPlayerPotentialMoves() {
        // We need to copy the board, so we do not modify the active gane
        let boardCopy = getBoardCopy(gameBoard)
        let validMoves = getValidMoves(board: boardCopy, tileState: .player)
        
        validMoves.forEach { location in
            gameBoard[location.xPos][location.yPos].state = .potentialPlayerMove
        }
    }
    
    /// Determine which moves are valid. We cycle through all cells in the game board and check
    /// whether that cell is a valid cell to select. If it is, we add it to an array of valid moves. We can
    /// use this to determine what cells the computer can move to.
    ///
    /// - Parameters:
    ///   - board: The game board to use to check against
    ///   - tileState: Whether this is a computer or player move
    ///
    /// - Returns: An array of possible moves.
    private func getValidMoves(board: GameBoard, tileState: TileState) -> [BoardLocation] {
        var validMoves: [BoardLocation] = []
        
        for x in 0..<boardWidth {
            for y in 0..<boardHeight {
                if let _ = isValidMove(board: board, tileState: tileState, xPos: x, yPos: y) {
                    validMoves.append(BoardLocation(xPos: x, yPos: y))
                }
            }
        }
        return validMoves
    }
    
    /// Calculates the score for the player and computer in the passed in game board. This could
    /// be the real game board or a copy of the game board used to determine the best score
    /// for the computer.
    ///
    /// - Parameter board: The board to be scanned
    /// - Returns: The player and computer scores on the board
    private func getScores(board: GameBoard) -> (player: Int, computer: Int) {
        let allTiles = board.flatMap({ $0 })
        let player = allTiles.filter({$0.state == .player}).count
        let computer = allTiles.filter({$0.state == .computer}).count
        
        return (player, computer)
    }
    
    @discardableResult
    private func makeMove(board: GameBoard, tileState: TileState, xPos: Int, yPos: Int) -> Bool {
        guard let tilesToFlip = isValidMove(board: board, tileState: tileState, xPos: xPos, yPos: yPos) else {
            return false
        }
        
        board[xPos][yPos].state = tileState
        tilesToFlip.forEach { location in
            board[location.xPos][location.yPos].state = tileState
        }
        return true
    }
    
    /// Checks whether a particular tile is on the corner of the board. Corner spots
    /// are highly prized for their tactical position.
    ///
    /// - Parameters:
    ///   - xPos: The x position on the board
    ///   - yPos: The y position on the board
    ///
    /// - Returns: True if the position is on a corner else false.
    private func isOnCorner(xPos: Int, yPos: Int) -> Bool {
        return (xPos == 0 || xPos == boardWidth - 1) && (yPos == 0 ||  yPos == boardHeight - 1)
    }
    
    /// Calculates the best move for the computer.
    ///
    /// - Returns: The location on the board that represents the best move for the
    /// computer; i.e. the one that captures a corner or that scores the highest score
    /// for the computer.
    private func getComputerMove() -> BoardLocation? {
        let boardCopy = getBoardCopy(gameBoard)
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .computer).shuffled()

        // Prefer moves that are on the corner
        var computerCornerMove: BoardLocation? = nil
        possibleMoves.forEach { location in
            if computerCornerMove == nil && isOnCorner(xPos: location.xPos, yPos: location.yPos)  {
                computerCornerMove = BoardLocation(xPos: location.xPos, yPos: location.yPos)
            }
        }
        if let computerCornerMove {
            return computerCornerMove
        }
        
        // Find the highest scoring move
        var bestScore = -1
        var bestMove: BoardLocation? = nil
        
        possibleMoves.forEach { location in
            let testCopy = getBoardCopy(gameBoard)
            
            makeMove(board: testCopy, tileState: .computer, xPos: location.xPos, yPos: location.yPos)
            let score = getScores(board: testCopy).computer
            
            if score > bestScore {
                bestScore = score
                bestMove = BoardLocation(xPos: location.xPos, yPos: location.yPos)
            }
        }
        return bestMove
    }
    
    /// Inordinatelt useful function to create a copy of a game board.
    ///
    /// - Parameter board: The board to copy
    /// - Returns: A new game board with the same data as the input board.
    ///
    /// Most of the game logic is based around trying out movesto find the best one. This
    /// is all done on a copy of the game board. Once we have determined the best move,
    /// we can apply it to the actual game that the player is seeing.
    ///
    /// This function is responsible for creating an empty game board and then copying the
    /// content of the passed in game board. The resulting board is a duplicate of the input
    /// one, but with new and unrelated Tile objects.
    private func getBoardCopy(_ board: GameBoard) -> [[Tile]] {
        let copy = createBoard()
        
        for x in 0..<boardWidth {
            for y in 0..<boardHeight {
                copy[x][y].state = board[x][y].state
            }
        }
        
        return copy
    }
}
