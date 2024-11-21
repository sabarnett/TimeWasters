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

@Observable
class CombinationsViewModel {
    
    /// The four numbers that are used to achieve the result
    var values: [FormulaValue] = [
        FormulaValue(0),
        FormulaValue(0),
        FormulaValue(0),
        FormulaValue(0)
    ]
    
    /// The expected result from the calculation
    var result: FormulaValue = FormulaValue(0)
    
    /// The result of the formula as the user enters it - it's supposed to help!
    var interimResult: Int = 0
    
    /// Error messages for the formula as the user enters it
    var formulaErrors: String = ""
    
    /// The user entered formula. We trap didSet so we can extract the
    /// numbers in the formula and adjust the state of the numbers shown
    /// on the screen.
    var formula: String = "" {
        didSet {
            formulaErrors = ""
            interimResult = 0
            validateFormula()
        }
    }
    
    /// Contains the formula we used to achieve the result. Note, this is not
    /// necessarily the formula the player will create. There may be more than one
    /// solution to the puzzle.
    var usedFormula: String = ""
    
    /// Used to show the game play popover
    var showGamePlay: Bool = false
    
    @ObservationIgnored
    var notify = PopupNotificationCentre.shared
    
    /// Generates a new puzzle by generating four numbers between 1 and 10 and a random
    /// formula. We then calculate the return from the formula and make this the target the
    /// player needs to achieve. All arithmetic is integer arithmetic, so dividing 3 by 2 results in 1.
    ///
    /// Now, we could use random numbers, but that gives us the possibility of getting the same
    /// number three or four times. That's not going to be a challenge. So, I use an array or ints,
    /// shuffled into random order. This way, we get rour digits but can never have the same number
    /// more than twice.
    func generatePuzzle() {
        let numbers = [1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10]
        let gameNumbers = numbers.shuffled()
        
        values = [
            FormulaValue(gameNumbers[0]),
            FormulaValue(gameNumbers[1]),
            FormulaValue(gameNumbers[2]),
            FormulaValue(gameNumbers[3])
        ]
        
        let generator = FormulaBuilder()
        if let (formula, result) = generator.generateRandomFormula(values: values) {
            self.usedFormula = formula
            self.result = FormulaValue(result)
        } else {
            // This should never happen - famous last words. If it does
            // lets not die, lets just go with a very simple formula.
            self.usedFormula = "\(values[0].value) + \(values[1].value  + values[2].value  + values[3].value)"
            result = FormulaValue(values[0].value + values[1].value + values[2].value + values[3].value)
        }

        self.formula = ""
    }
    
    // MARK :- Formula parsing to highlight selected numbers
    
    /// Takes the user entered formula and attempts to evaluate it. If we can calculate
    /// a result, we display this to help the user. If we can't evaluate the formula, we
    /// display an appropriate message.
    private func validateFormula() {
        if formula.isEmpty { return }

        let numbers = getFormulaNumbers()
        setInUseIndicators(numbers: numbers)
        
        let eval = FormulaEvaluator()
        do {
            let result = try eval.evaluate(expression: formula)
            self.interimResult = result
        } catch EvaluationErrors.invalidCharacter(let character) {
            self.formulaErrors = "Invalid character: \(character)"
        } catch EvaluationErrors.unknownOperator(let op) {
            self.formulaErrors = "Unknown operator: \(op)"
        } catch EvaluationErrors.unexpectedToken {
            self.formulaErrors = "Invalid input characters"
        } catch EvaluationErrors.divideByZero {
            self.formulaErrors = "Can't divide by zero"
        } catch EvaluationErrors.incompleteFormula {
            self.formulaErrors = "Incomplete formula"
        } catch {
            self.formulaErrors = error.localizedDescription
        }
        
        if interimResult == result.value {
            print("Value achieved!")
        }
    }
    
    private func getFormulaNumbers() -> [String] {
        guard let regex = try? NSRegularExpression(pattern: "\\d+", options: []) else { return [] }
        
        let matches = regex.matches(in: formula, options: [], range: NSRange(formula.startIndex..<formula.endIndex, in: formula))
        let numbers = matches.map {
            String(formula[Range($0.range, in: formula)!])
        }
        
        return numbers
    }

    private func setInUseIndicators(numbers: [String]) {
        for index in 0..<values.count {
            values[index].isUsed = false
        }

        for match in numbers {
            let number = Int(match)
            if let displayItem = values.firstIndex(where: { $0.value == number && !$0.isUsed }) {
                values[displayItem].isUsed = true
            }
        }
    }
    
    func showSolution() {
        notify.showPopup(
            systemImage: "squareshape.split.2x2",
            title: usedFormula,
            description: "The formula used was \(usedFormula)"
        )
    }
}

struct FormulaValue {
    
    var value: Int
    var isUsed: Bool = false
    
    init(_ value: Int) {
        self.value = value
    }
    
    var color: Color {
        isUsed ? .gray : .blue
    }
}
