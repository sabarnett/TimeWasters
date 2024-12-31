//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 31/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

enum LeaderBoardScoreFor {
    case player, computer
}

@Observable
class LeaderBoard {
    
    // Leader board by game level
    var leaderBoard: LeaderBoardData = LeaderBoardData()
    
    init () {
        loadLeaderBoard()
    }
    
    func addLeader(score: Int, for level: LeaderBoardScoreFor) {
        // based on the game level, add the score to the leader board
        // if it is better than any other score.
        var requiresSave = false
        switch level {
        case .player:
            requiresSave = addScoreForPlayer(score: score)
        case .computer:
            requiresSave = addScoreForComputer(score: score)
        }
        
        // Save the leader board if we changed it.
        if requiresSave {
            saveLoaderBoard()
        }
    }
    
    private func addScoreForPlayer(score: Int) -> Bool {
        if leaderBoard.playerLeaderBoard.count == 5 {
            if let maxScore = leaderBoard.playerLeaderBoard.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }
        
        leaderBoard.playerLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.playerLeaderBoard.sorted(by: { $0.gameScore > $1.gameScore })
        
        leaderBoard.playerLeaderBoard = Array(newScores.prefix(5))
        return true
    }
    
    private func addScoreForComputer(score: Int) -> Bool {
        if leaderBoard.computerLeaderBoard.count == 5 {
            if let maxScore = leaderBoard.computerLeaderBoard.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }
        
        leaderBoard.computerLeaderBoard.append(LeaderBoardItem(playerName: "Computer", gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.computerLeaderBoard.sorted(by: { $0.gameScore > $1.gameScore })
        
        leaderBoard.computerLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    /// Load tghe leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: "OthelloLeaderBoard")
        
        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }
    
    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "OthelloLeaderBoard")

        // Json encode and save the file
        let encoded = try! JSONEncoder().encode(leaderBoard)
        try? encoded.write(to: saveFileUrl, options: .atomic)
    }
    
    /// Generate the file name to save the data to or to reload the data from.
    ///
    /// - Parameter gameDefinition: The definition of the game
    ///
    /// - Returns: The URL to use to save the file. It is based on the name of the
    /// game file and will be saved to the users document directory.
    private func fileUrl(file: String) -> URL {
        let fileName = file + ".save"
        return URL.documentsDirectory.appendingPathComponent(fileName)
    }
}

struct LeaderBoardData: Codable {
    var playerLeaderBoard: [LeaderBoardItem] = []
    var computerLeaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    
    var playerName: String = NSFullUserName()
    var gameDate: Date
    var gameScore: Int
}
