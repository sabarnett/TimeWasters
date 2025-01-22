//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 22/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class LeaderBoard {
    
    // Leader board by game level
    var leaderBoard: LeaderBoardData = LeaderBoardData()
    
    init () {
        loadLeaderBoard()
    }
    
    func addLeader(score: Int, for level: GameDifficulty) {
        var requiresSave = false

        switch level {
        case .easy:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.easyLeaderBoard)
        case .medium:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.mediumLeaderBoard)
        case .hard:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.hardLeaderBoard)
        }
        
        if requiresSave {
            saveLoaderBoard()
        }
    }
    
    func clearScores() {
        leaderBoard.mediumLeaderBoard.removeAll()
        leaderBoard.easyLeaderBoard.removeAll()
        leaderBoard.hardLeaderBoard.removeAll()
        saveLoaderBoard()
    }

    private func addLeaderBoard(score: Int, to scores: inout [LeaderBoardItem]) -> Bool {
        if scores.count == 5 {
            if let maxScore = scores.max(by: { $0.gameScore > $1.gameScore }) {
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
        let loadFileUrl = fileUrl(file: "MatchedPairsLeaderBoard")
        
        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }
    
    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "MatchedPairsLeaderBoard")

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
    var easyLeaderBoard: [LeaderBoardItem] = []
    var mediumLeaderBoard: [LeaderBoardItem] = []
    var hardLeaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    
    var playerName: String = NSFullUserName()
    var gameDate: Date
    var gameScore: Int
}
