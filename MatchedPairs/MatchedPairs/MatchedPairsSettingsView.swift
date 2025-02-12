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
    
    @AppStorage(Constants.autoFlip) private var autoFlip: Bool = false
    @AppStorage(Constants.autoFlipDelay) private var autoFlipDelay: Double = 5
    
    @State private var bgID: Int? = 0
    
    var formattedDelay: String {
        autoFlipDelay.formatted(.number.precision(.integerLength(2)))
    }
    
    public init() { }
    
    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $playSounds)
                .padding(.bottom, 8)

            Picker("Game difficulty", selection: $gameDifficulty) {
                ForEach(GameDifficulty.allCases) { difficulty in
                    Text(difficulty.description)
                        .tag(difficulty)
                }
            }
            .padding(.bottom, 8)

            Toggle("Auto-flip", isOn: $autoFlip)
            HStack {
                Slider(value: $autoFlipDelay, in: 2...20, step: 1.0)
                Text(" (\(formattedDelay) (seconds)")
                    .font(.caption)
            }
            .disabled(!autoFlip)
            .padding(.bottom, 8)

            // This is a fudge. If I apply tghe label to the ScrollViewCarouselView
            // the label aligns with the bottom. So I apply the label to the
            // instructions and put the control after it without a label.
            LabeledContent("Card Background") {
                    Text("Scroll to select card background")
            }
            ScrollViewCarouselView(scrollID: $bgID)
                .padding(.bottom, 8)
        }
        .frame(width: 350)
        .padding()
        .onAppear {
            bgID = cardBackground.id
        }
        .onDisappear {
            cardBackground = CardBackgrounds.allCases.first(where: {$0.id == bgID })!
        }
    }

}

#Preview {
    MatchedPairsSettingsView()
}
