//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 10/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct WordCraftSettingsView: View {
    
    @AppStorage(Constants.wordcraftPlaySounds) private var wordcraftPlaySounds = true
    @AppStorage(Constants.wordcraftShowUsedWords) private var wordcraftShowUsedWords = true

    public init() { }
    
    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $wordcraftPlaySounds)
            Toggle("Show used words list", isOn: $wordcraftShowUsedWords)
        }
        .padding()
    }
}

#Preview {
    WordCraftSettingsView()
}