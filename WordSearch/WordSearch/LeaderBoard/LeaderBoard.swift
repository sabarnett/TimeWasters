//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 04/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//


import Foundation

@Observable
class LeaderBoard {
    
    private var leaderBoard: LeaderBoardData = LeaderBoardData()
    
    var playerLeaderBoard: [LeaderBoardItem] { leaderBoard.playerLeaderBoard }
    
    init () {
        loadLeaderBoard()
    }
    
    /// Adds a score to the leader board. The score will be for the player.
    /// We cannot assume that the score is eligible for the
    /// high score list, so we need to check it is a high score.
    ///
    /// - Parameters:
    ///   - score: The potential high score.
    func addLeader(score: Int) {
        var requiresSave = false

        requiresSave = addLeaderBoard(score: score,
                                      to: &leaderBoard.playerLeaderBoard)
        
        if requiresSave {
            saveLoaderBoard()
        }
    }
    
    /// Clear the leader board
    func clearScores() {
        leaderBoard.playerLeaderBoard.removeAll()
        saveLoaderBoard()
    }
    
    private func addLeaderBoard(score: Int, to scores: inout [LeaderBoardItem]) -> Bool {
        if scores.count == 5 {
            if let maxScore = scores.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }
        
        let scoreItem = LeaderBoardItem(gameDate: Date.now, gameScore: score)
        
        scores.append(scoreItem)
        scores.sort(by: {$0.gameScore < $1.gameScore})
        if scores.count > 5 {
            scores.removeLast()
        }
        
        return true
    }

    /// Load the leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: Constants.leaderBoardFileName)
        
        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }
    
    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: Constants.leaderBoardFileName)

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
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    
    var playerName: String = NSFullUserName()
    var gameDate: Date
    var gameScore: Int
}
