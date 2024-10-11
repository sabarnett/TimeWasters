//
//  ViewModel.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//

import SwiftUI
import AVKit

@Observable
class WordCraftViewModel {

    @ObservationIgnored
    @AppStorage(Constants.wordcraftPlaySounds) private var wordcraftPlaySounds = true {
        didSet {
            updateSounds()
        }
    }

    var columns = [[Tile]]()

    private var selected = [Tile]()
    var usedWords = Set<String>()
    var score = 0
    var selectedLetters: [Tile] = []
    var speakerIcon: String = "speaker.fill"

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
        
        speakerIcon = wordcraftPlaySounds ? "speaker.slash.fill" : "speaker.fill"
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
        
        playTileDropSound()
        
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
    
    // MARK: - Souond functions
    
    private var sounds: AVAudioPlayer!
    private var tileDrop: AVAudioPlayer!
    private var backgroundURL: URL { soundFile(named: "background") }
    private var splatURL: URL { soundFile(named: "splat") }

    /// Play the background music
    func playBackgroundSound() {
        playSound(backgroundURL, repeating: true)
    }
    
    /// If the background music is playing, stop it.
    func stopSounds() {
        if sounds != nil {
            sounds.stop()
        }
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playTileDropSound() {
        guard wordcraftPlaySounds else { return }
        tileDrop = try? AVAudioPlayer(contentsOf: splatURL)
        tileDrop.play()
    }
    
    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        wordcraftPlaySounds.toggle()
    }
    
    private func updateSounds() {
        speakerIcon = wordcraftPlaySounds ? "speaker.slash.fill" : "speaker.fill"

        if wordcraftPlaySounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }
    
    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: WordCraftViewModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false) {
        guard wordcraftPlaySounds else { return }
        if sounds != nil { sounds.stop() }
        
        sounds = try! AVAudioPlayer(contentsOf: url)
        sounds.numberOfLoops = repeating ? -1 : 0
        self.sounds.play()
    }

}
