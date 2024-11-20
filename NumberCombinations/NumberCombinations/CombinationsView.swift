//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 19/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct CombinationsView: View {
    
    @AppStorage(Constants.ncDisplayInterimResult) private var displayInterimResult: Bool = false
    
    @State public var gameData: Game
    @State var model = CombinationsViewModel()
    
    public init(gameData: Game) {
        self.gameData = gameData
    }
    
    public var body: some View {
        VStack {
            topBarAndButtons
                .padding(.horizontal, 8)
            Spacer()

            HStack {
                VStack {
                    HStack {
                        DisplayNumber(model.values[0])
                        DisplayNumber(model.values[1])
                    }
                    HStack {
                        DisplayNumber(model.values[2])
                        DisplayNumber(model.values[3])
                    }
                }
                Text("=")
                    .font(.system(size: 48, weight: .bold))
                DisplayNumber(model.result, asResult: true)
            }
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 0){
                HStack {
                    TextField("Enter your formula", text: $model.formula)
                        .font(.title2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if displayInterimResult {
                        Text(" = \(model.interimResult)")
                            .font(.title2)
                    }
                }
                .frame(maxWidth: 460)
                Text(model.formulaErrors)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .onAppear { model.generatePuzzle() }
        .sheet(isPresented: $model.showGamePlay) {
            GamePlayView(game: gameData)
        }
        .frame(width: 600, height: 360)
    }
    
    var topBarAndButtons: some View {
        HStack {
            Button(action: { model.showGamePlay.toggle() }) {
                Image(systemName: "questionmark.circle.fill")
                    .padding(.vertical, 5)
            }
            .buttonStyle(.plain)
            .help("Show game rules")
            
            Spacer()

            Button(action: { model.generatePuzzle() }) {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .padding(.vertical, 5)
            }
            .buttonStyle(.plain)
            .help("Restart the game")

            Button(action: { model.showSolution() }) {
                Image(systemName: "squareshape.split.2x2")
                    .padding(.vertical, 5)
            }
            .buttonStyle(.plain)
            .help("Show/Hide the solution")

//            Button(action: { game.toggleSounds() }) {
//                Image(systemName: game.speakerIcon)
//                    .padding(5)
//            }
//            .buttonStyle(.plain)
//            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }

}

#Preview {
    CombinationsView(gameData: Games().games.first(where: { $0.id == "numberCombinations" } )!)
}
