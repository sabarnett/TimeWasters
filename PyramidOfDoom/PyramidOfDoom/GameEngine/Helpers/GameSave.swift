//
// -----------------------------------------
// Original project: PyramidOfDoom
// Original package: PyramidOfDoom
// Created on: 02/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

struct GameSave {
    
    /// Save the current game to a file so we can restore it later.
    ///
    /// - Parameter game: The game to be saved
    ///
    /// Saving a game consists of saving a fixed number of items to a JSOn file. We
    /// need to save:
    ///
    /// Counters
    /// RoomSaved
    /// BitFlags - DarkBit
    /// My Location
    /// CurrentCounter
    /// SavedRoom
    /// GameHeader
    /// LightTime
    /// For each item, save it's locaton
    ///
    /// As a helper to the player, we save the last 25 interactions (messages and commands) just so the
    /// console is not completely blank when the restore the file.
    func save(game: AdventureGame, progress: [GameDataRow], gameDefinition: GameDefinition) {
        // Get the save file name
        let saveFileTo = saveFileUrl(gameDefinition: gameDefinition)
        
        // Helper object for the save data
        var saveData = GameSaveData()
        
        // Save the counters
        for index in 0..<game.counters.NumberOfCounters {
            saveData.counters.append(game.counters.getCounter(atIndex: index))
        }
        for room in game.savedRooms {
            saveData.roomSaved.append(room)
        }
        for flagIndex in 0..<game.flags.NFLAGS {
            saveData.flags.append(game.flags[flagIndex])
        }
        saveData.darkFlag = game.flags.dark_flag
        saveData.myLocation = game.location
        saveData.currentCounter = game.counter
        saveData.savedRoom = game.savedRoom
        saveData.lightTime = game.gameHeader.LightTime
        saveData.lampLeft = game.lampLeft
        for item in game.items {
            saveData.itemLocation.append(item.Location)
        }
        
        // Save the progress view
        let startAt = progress.count <= 25 ? 0 : progress.count - 25
        for index in startAt..<progress.count {
            let prefix = progress[index].dataType == .consoleOutput ? ">>>" : ""
            saveData.gameProgress.append("\(prefix)\(progress[index].text)")
        }
        
        // Json encode and save the file
        let encoded = try! JSONEncoder().encode(saveData)
        try? encoded.write(to: saveFileTo, options: .atomic)
        
        print("Save game written to \(saveFileTo.path())")
    }
    
    /// Restore a saved game
    ///
    /// - Parameter game: The game to be restored
    ///
    /// Restoring a saved game consists of reloading:
    ///
    /// Counters and RoomSaved (16 of them)
    /// Dark Flag
    /// My Location
    /// Current Counter
    /// Saved Room
    /// Game Header
    /// Light Time
    /// For each item, restore it's location
    ///
    /// We also saved the last 25 interactions with the user, so we put those back too so the user has
    /// some context of where they were when the game was saved.
    /// 
    func restore(game: inout AdventureGame, progress: inout [GameDataRow], gameDefinition: GameDefinition) {
        
        progress.removeAll()
    }
    
    /// Generate the file name to save the data to or to reload the data from.
    ///
    /// - Parameter gameDefinition: The definition of the game
    ///
    /// - Returns: The URL to use to save the file. It is based on the name of the
    /// game file and will be saved to the users document directory.
    private func saveFileUrl(gameDefinition: GameDefinition) -> URL {
        let saveFileName = gameDefinition.file + ".save"
        return URL.documentsDirectory.appendingPathComponent(saveFileName)
    }
    
}

/// Helper object - this is what we will use to save the JSON data.
fileprivate struct GameSaveData: Codable {
    // Save game date
    var saveDate: Date = .now
    
    // Counters & roomSaved
    var counters: [Int] = []
    var roomSaved: [Int] = []
 
    // Dark Flag
    var flags: [Bool] = []
    var darkFlag: Bool = false
    
    // State values
    var myLocation: Int = 0
    var currentCounter: Int = 0
    var savedRoom: Int = 0
    var lightTime: Int = 0
    var lampLeft: Int = 0
    
    // Item locations
    var itemLocation: [Int] = []
    
    // Game progress - last 25 lines
    var gameProgress: [String] = []
}
