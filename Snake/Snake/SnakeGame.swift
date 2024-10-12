//
// -----------------------------------------
// Original project: SnakeGPT
// Original package: SnakeGPT
// Created on: 04/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum Direction {
    case up, down, left, right
}

struct Position: Equatable, Hashable {
    var x: Int
    var y: Int
}

struct SnakeGame {
    
    var snake: [Position] = [Position(x: 10, y: 10)]
    var food: Position = Position(x: Int.random(in: 0..<20), y: Int.random(in: 0..<20))
    var direction: Direction = .right
    var isGameOver = false
    var gridSize = 20

    mutating func moveSnake() {
        guard !isGameOver else { return }
        
        var newHead = snake[0]

        switch direction {
        case .up:
            newHead.y -= 1
        case .down:
            newHead.y += 1
        case .left:
            newHead.x -= 1
        case .right:
            newHead.x += 1
        }

        // Check for wall collision
        if newHead.x < 0 || newHead.x >= gridSize || newHead.y < 0 || newHead.y >= gridSize {
            isGameOver = true
            return
        }

        // Check for self collision
        if snake.contains(newHead) {
            isGameOver = true
            return
        }

        // Move snake
        snake.insert(newHead, at: 0)
        
        // Check for food
        if newHead == food {
            food = Position(x: Int.random(in: 0..<gridSize), y: Int.random(in: 0..<gridSize))
        } else {
            snake.removeLast()  // Remove the tail if no food is eaten
        }
    }
    
    mutating func changeDirection(newDirection: Direction) {
        // Prevent snake from reversing direction
        if (newDirection == .up && direction != .down) ||
           (newDirection == .down && direction != .up) ||
           (newDirection == .left && direction != .right) ||
           (newDirection == .right && direction != .left) {
            direction = newDirection
        }
    }
    
    mutating func resetGame() {
        snake = [Position(x: 10, y: 10)]
        food = Position(x: Int.random(in: 0..<20), y: Int.random(in: 0..<20))
        direction = .right
        isGameOver = false
    }
}
