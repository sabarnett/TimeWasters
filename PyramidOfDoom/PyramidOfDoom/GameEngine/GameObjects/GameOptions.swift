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

public struct GameOptions {

    public init() {

    }
    
    public var WizardMode: Bool = false
    public var RestoreFile: Bool = false
    public var ReadFile: Bool = false
    public var EchoInput: Bool = false
    public var BugTolerant: Bool = true
    public var NoWait: Bool = false
    public var ShowTokens: Bool = false
    public var ShowRandom: Bool = false
    public var ShowParse: Bool = false
    public var ShowConditions: Bool = false
    public var ShowInstructions: Bool = false
    public var ShowMessages: Bool = true
    public var ShowRooms: Bool = true
    public var ShowActions: Bool = true
    public var ShowItems: Bool = true
}

