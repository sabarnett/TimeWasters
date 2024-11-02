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
