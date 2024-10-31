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

public class ListManager {

    public static var wordLength: Int = 0

    public class func find(word: String, inList: [String]) -> Int {

        if word.count == 0 {
            return 0
        }

        let searchWord = word.uppercased().prefix(wordLength)
        for var index in 0..<inList.count {

            // Get the raw command. It may have an asterisk prefix!
            let testCase = inList[index].uppercased()

            if testCase == searchWord {
                return index
            } else if testCase.hasPrefix("*") && testCase.count > 1 {
                // Generate the command without the asterisk prefix.
                let index2 = testCase.index(testCase.startIndex, offsetBy: 1)
                let testCase2 = testCase[index2...]

                if (searchWord == testCase2) {
                    while inList[index].hasPrefix("*") {
                        index -= 1
                    }
                    return index
                }
            }
        }

        return 0
    }
}
