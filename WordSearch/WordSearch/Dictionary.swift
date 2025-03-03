//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 03/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

struct Dictionary {
    
    private var dictionary: Set<String> = []
    
    init() {
        dictionary = load()
    }
    
    private func load() -> Set<String> {
        guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else {
            fatalError("Couldn't locate dictionary.txt")
        }

        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Couldn't load dictionary.txt")
        }

        // Build the list taking only words getween 3 and 12 letters. This gives us
        // around 102,000 words to check against.
        return Set(contents.components(separatedBy: .newlines)
//            .filter({ $0.count > 2 && $0.count < 13})
       )
    }
                   
    func filtered(wordMinLength: Int = 3, wordMaxLength: Int = 12) -> Set<String> {
        return dictionary.filter {
            $0.count >= wordMinLength && $0.count <= wordMaxLength
        }
    }
}
