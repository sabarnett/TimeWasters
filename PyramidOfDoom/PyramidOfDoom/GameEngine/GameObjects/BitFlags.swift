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

public class BitFlags {

    private let NFLAGS = 32         //The most that will fit in a single 4-byte integer
    private let FLAG_DARK = 15      // Fixed flag
    private let FLAG_LAMPDEAD = 16  // Fixed flag

    private var flags: [Bool] = [Bool]()

    init() {
        flags = [Bool](repeating: false, count: NFLAGS)
    }

    // MARK:- Specific flag helpers

    var lamp_dead: Bool {
        get { return flags[FLAG_LAMPDEAD] }
        set(newFlag) { flags[FLAG_LAMPDEAD] = newFlag }
    }

    var dark_flag: Bool {
        get { return flags[FLAG_DARK] }
        set(newFlag) { flags[FLAG_DARK] = newFlag }
    }

    // MARK:- Generic get/set flag methods

    subscript(index: Int) -> Bool {
        get {
            validateFlagIndex(index)
            return flags[index]
        }
        set (newValue) {
            validateFlagIndex(index)
            flags[index] = newValue
        }
    }
}

// MARK: - Private validation methods

extension BitFlags {

    private func validateFlagIndex(_ index: Int) {
        if index >= 0 && index <= NFLAGS {
            return;
        }

        fatalError("Invalid flag index requested: \(index)")
    }
}

