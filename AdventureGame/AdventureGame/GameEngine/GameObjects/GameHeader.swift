//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

public class GameHeader {
    // First 12 settings in the file. Many of these settings drove the
    // the loading of the game.
    //
    // Note: There is an unknown value at the start of the file and at the
    // end of the file - no idea what these are, but I store them anyway in case
    // I eventually find out.
    public var Unknown: Int = 0
    public var NumberOfItems: Int = 0
    public var NumberOfActions: Int = 0
    public var NumberOfWords: Int = 0
    public var NumberOfRooms: Int = 0
    public var MaximumCarryItems: Int = 0
    public var PlayerRoom: Int = 0
    public var Treasures: Int = 0
    public var WordLength: Int = 0
    public var LightTime: Int = 0
    public var NumberOfMessages: Int = 0
    public var TreasureRoom: Int = 0

    // These are read from the trailer of the file, not the header.
    public var GameVersion: Int = 0
    public var GameId: Int = 0
    public var GameTrailer: Int = 0

    public func load(fromDataFile dataFile: GameDataReaderProtocol) {

        self.Unknown = try! dataFile.readInt()
        self.NumberOfItems = try! dataFile.readInt()
        self.NumberOfActions = try! dataFile.readInt()
        self.NumberOfWords = try! dataFile.readInt()
        self.NumberOfRooms = try! dataFile.readInt()
        self.MaximumCarryItems = try! dataFile.readInt()
        self.PlayerRoom = try! dataFile.readInt()
        self.Treasures = try! dataFile.readInt()
        self.WordLength = try! dataFile.readInt()
        self.LightTime = try! dataFile.readInt()
        self.NumberOfMessages = try! dataFile.readInt()
        self.TreasureRoom = try! dataFile.readInt()

    }
}
