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
// Developer note: The .position modifier calculates the center point of the
// rectangles we are using to build the display. So, everywhere we calculate
// a position, we need to add half a cell size to keep the rectangle on the
// playing area.
//

import SwiftUI
import SharedComponents

public struct SnakeGameView: View {

    @State public var gameData: Game
    
    @State private var game = SnakeGame()
    @State private var timer: Timer?
    @State private var pause: Bool = true
    @State private var showGamePlay: Bool = false
    
    let cellSize: CGFloat = 20
    
    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        ZStack {
            VStack {
                topBarAndButtons
                    .padding(.horizontal, 8)
                
                ZStack {
                    ForEach(game.snake, id: \.self) { segment in
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: cellSize, height: cellSize)
                            .position(x: CGFloat(segment.x) * cellSize + cellSize / 2,
                                      y: CGFloat(segment.y) * cellSize + cellSize / 2)
                    }
                    
                    Image(systemName: "applelogo")
                        .scaleEffect(1.8)
                        .foregroundStyle(.red)
                        .frame(width: cellSize, height: cellSize)
                        .position(x: CGFloat(game.food.x) * cellSize + cellSize / 2,
                                  y: CGFloat(game.food.y) * cellSize + cellSize / 2)
                    
                    if pause {
                        Image(systemName: "pause.circle.fill")
                            .scaleEffect(4)
                            .zIndex(1)
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: cellSize * CGFloat(game.gridSize), height: cellSize * CGFloat(game.gridSize))
                .background(Color.black)
                .border(Color.red, width: 1)
            }.disabled(game.isGameOver)
                        
            if game.isGameOver {
                GameOverView() {
                    withAnimation {
                        restartGame()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startGameLoop()
        }
        .onDisappear {
            game.stopSounds()
            timer?.invalidate()
        }
        .frame(width: cellSize * CGFloat(game.gridSize + 2), height: cellSize * CGFloat(game.gridSize) + 80)
        .background(Color.black)
        .overlay(
            KeyEventHandlingView { event in
                handleKeyPress(event)
            }
                .frame(width: 0, height: 0)  // Invisible but captures keyboard input
        )
        .sheet(isPresented: $showGamePlay) {
            GamePlayView(game: gameData)
        }
    }
    
    var topBarAndButtons: some View {
        HStack {
            Button(action: { showGamePlay.toggle() }) {
                Image(systemName: "questionmark.circle.fill")
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Show game rules")
            
            Spacer()
            
            Text(game.snake.count.formatted(.number.precision(.integerLength(3))))
                            .fixedSize()
                            .padding(.horizontal, 6)
                            .foregroundStyle(.red.gradient)
            Spacer()
            
            Button(action: { restartGame() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Restart the game")
            
            Button(action: { game.toggleSounds() }) {
                Image(systemName: game.speakerIcon)
                    .padding(5)
            }
            .buttonStyle(.plain)
            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .background(.black)
        .clipShape(.rect(cornerRadius: 10))
    }
    
    func startGameLoop() {
        game.playBackgroundSound()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            guard pause == false else { return }
            game.moveSnake()
        }
    }
    
    func handleKeyPress(_ event: NSEvent) {
        switch event.keyCode {
        case 49:    // Space bar
            pause.toggle()
        case 123:  // Left arrow
            game.changeDirection(newDirection: .left)
        case 124:  // Right arrow
            game.changeDirection(newDirection: .right)
        case 125:  // Down arrow
            game.changeDirection(newDirection: .down)
        case 126:  // Up arrow
            game.changeDirection(newDirection: .up)
        default:
            break
        }
    }
    
    private func restartGame() {
        game.resetGame()
        startGameLoop()
    }
}

#Preview {
    SnakeGameView(gameData: Games().games.first(where: { $0.id == "snake" } )!)
}
