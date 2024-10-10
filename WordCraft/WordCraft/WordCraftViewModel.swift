//
//  ViewModel.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//

import SwiftUI

@Observable
class WordCraftViewModel {
    var columns = [[Tile]]()

    private var selected = [Tile]()
    var usedWords = Set<String>()
    var score = 0
    var selectedLetters: [Tile] = []

    private var targetLetter = "A"
    private var targetLength = 0

    var currentRule: Rule!

    let dictionary: Set<String> = {
        guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else {
            fatalError("Couldn't locate dictionary.txt")
        }

        guard let contents = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Couldn't load dictionary.txt")
        }

        return Set(contents.components(separatedBy: .newlines))
    }()

    init() {
        reset()
    }
    
    func reset() {
        columns = [[Tile]]()
        
        for i in 0..<5 {
            var column = [Tile]()

            for _ in 0..<8 {
                let piece = Tile(column: i)
                column.append(piece)
            }
            
            columns.append(column)
        }

        selectRule()
        usedWords = []
        selected.removeAll()
        selectedLetters = []
        score = 0
    }

    func select(_ tile: Tile) {
        if selected.last == tile && selected.count >= 3 {
            checkWord()
        } else if let index = selected.firstIndex(of: tile) {
            if selected.count == 1 {
                selected.removeLast()
            } else {
                selected.removeLast(selected.count - index - 1)
            }
        } else {
            // Try to trap tripple tap. Not working!
            if tileIsValid(tile) {
                selected.append(tile)
            }
        }
        selectedLetters = selected.map { $0 }
    }

    // If a user tripple taps the last letter, the last time may be
    // added even though it no longer exists on the game board. This
    // function ensures that, before we add a selecxted tile, it is
    // still in play.
    func tileIsValid(_ tile: Tile) -> Bool {
        // Make sure the tile is still in play
        for row in columns {
            if row.contains(tile) {
                return true
            }
        }
        
        return false
    }
    
    func background(for tile: Tile) -> Color {
        if selected.contains(tile) {
            .white
        } else {
            .blue
        }
    }

    func foreground(for tile: Tile) -> Color {
        if selected.contains(tile) {
            .black
        } else {
            .white
        }
    }

    func remove(_ tile: Tile) {
        guard let position = columns[tile.column].firstIndex(of: tile) else { return }

        withAnimation {
            columns[tile.column].remove(at: position)
            columns[tile.column].insert(Tile(column: tile.column), at: 0)
        }
    }

    func checkWord() {
        let word = selected.map(\.letter).joined()

        guard usedWords.contains(word) == false else { return }
        guard dictionary.contains(word.lowercased()) else { return }
        guard currentRule.predicate(word) else { return }
        
        for tile in selected {
            remove(tile)
        }

        withAnimation {
            selectRule()
        }

        selected.removeAll()
        selectedLetters = selected.map { $0 }
        usedWords.insert(word)

        score += word.count * word.count
    }

    func startsWithLetter(_ word: String) -> Bool {
        word.starts(with: targetLetter)
    }

    func containsLetter(_ word: String) -> Bool {
        word.contains(targetLetter)
    }

    func doesNotContainLetter(_ word: String) -> Bool {
        word.contains(targetLetter) == false
    }

    func isLengthN(_ word: String) -> Bool {
        word.count == targetLength
    }

    func isAtLeastLengthN(_ word: String) -> Bool {
        word.count >= targetLength
    }

    func beginsAndEndsSame(_ word: String) -> Bool {
        word.first == word.last
    }

    func hasUniqueLetters(_ word: String) -> Bool {
        word.count == Set(word).count
    }

    func containsTwoAdjacentVowels(_ word: String) -> Bool {
        word.contains("AA")
        || word.contains("EE")
        || word.contains("II")
        || word.contains("OO")
        || word.contains("UU")
    }

    func hasEqualVowelsAndConsonants(_ word: String) -> Bool {
        var vowels = 0
        var consonants = 0
        let vowelsSet: Set<Character> = ["A", "E", "I", "O", "U"]

        for letter in word {
            if vowelsSet.contains(letter) {
                vowels += 1
            } else {
                consonants += 1
            }
        }

        return vowels == consonants
    }

    func count(for letter: String) -> Int {
        var count = 0

        for column in columns {
            for tile in column {
                if tile.letter == letter {
                    count += 1
                }
            }
        }

        return count
    }

    func selectRule() {
        let safeLetters = "ABCDEFGHILMNOPRSTUW".map(String.init)
        targetLetter = safeLetters.filter { count(for: $0) >= 2 }.randomElement() ?? "A"
        targetLength = Int.random(in: 3...6)

        let rules = [
            Rule(name: "Starts with \(targetLetter)", predicate: startsWithLetter),
            Rule(name: "Contains \(targetLetter)", predicate: containsLetter),
            Rule(name: "Does not contain \(targetLetter)", predicate: doesNotContainLetter),
            Rule(name: "Contains two identical adjacent vowels", predicate: containsTwoAdjacentVowels),
            Rule(name: "Has exactly \(targetLength) letters", predicate: isLengthN),
            Rule(name: "Has at least \(targetLength) letters", predicate: isAtLeastLengthN),
            Rule(name: "Begins and ends with the same letter", predicate: beginsAndEndsSame),
            Rule(name: "Uses each letter only once", predicate: hasUniqueLetters),
            Rule(name: "Has equal vowels and consonants", predicate: hasEqualVowelsAndConsonants)
        ]

        let newRule = rules.randomElement()!

        if newRule.name.contains("at least") && targetLength == 3 {
            selectRule()
        } else {
            currentRule = newRule
        }
    }
}
