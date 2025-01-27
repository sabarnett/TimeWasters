//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 22/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

enum CardBackgrounds: Int, Identifiable, CaseIterable {
    case one, two, three, four, five
    
    var id: Int { self.rawValue}
    
    var cardImage: String {
        switch self {
        case .one:
            return "back_01"
        case .two:
            return "back_02"
        case .three:
            return "back_03"
        case .four:
            return "back_04"
        case .five:
            return "back_05"
        }
    }
    
    var cardTitle: String {
        switch self {
        case .one:
            return "Black Maze"
        case .two:
            return "Red Maze"
        case .three:
            return "Brick Diamond"
        case .four:
            return "Moon"
        case .five:
            return "Stacked Stones"
        }
    }
}
public struct MatchedPairsSettingsView: View {
    
    let myBundle = Bundle(for: MatchedPairsGameModel.self)

    @AppStorage(Constants.playSound) private var playSounds = true
    @AppStorage(Constants.gameDifficulty) private var gameDifficulty: GameDifficulty = .easy
    @AppStorage(Constants.cardBackground) private var cardBackground: CardBackgrounds = .one
    
    public init() { }
    
    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $playSounds)
            
            Picker("Game difficulty", selection: $gameDifficulty) {
                ForEach(GameDifficulty.allCases) { difficulty in
                    Text(difficulty.description)
                        .tag(difficulty)
                }
            }
            
            LabeledContent("Card Background") {
                List(selection: $cardBackground) {
                    ForEach(CardBackgrounds.allCases) { background in
                        HStack(alignment: .top) {
                            Image(background.cardImage, bundle: myBundle)
                                .resizable()
                                .frame(width: 80, height: 125)
                            Text(background.cardTitle)
                                .font(.body)
                            Spacer()
                        }
                        .id(background)
                    }
                }
                .frame(height: 200)
            }
        }
        .frame(width: 350)
        .padding()
    }

}

#Preview {
    MatchedPairsSettingsView()
}
