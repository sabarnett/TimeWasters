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

public class GameAction {

    public var Verb: Int = 0
    public var Noun: Int = 0
    public var Conditions: [ActionCondition] = Array<ActionCondition>()
    public var Instructions: [ActionInstruction] = Array<ActionInstruction>()
    public var Args: [Int] = Array<Int>()
    public var Comment: String = ""
    private let game: Adventure

    init(forGame: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {
        game = forGame

        let verbNoun = try! dataFile.readInt()
        var conds: [ActionCondition] = [ActionCondition]()
        var args: [Int] = [Int]()

        for _ in 0...4 {
            let condValue = try! dataFile.readInt()

            let condition = condValue % 20
            let conditionValue = condValue / 20

            if condition == 0 {
                args.append(conditionValue)
            } else {
                let actionCondition = ActionCondition(forGame: forGame, withCondition: condition, usingValue: conditionValue)
                conds.append(actionCondition)
            }
        }

        var instructions = [ActionInstruction]()

        for _ in 0...1 {
            let instr = try! dataFile.readInt()

            let id1: Int = instr / 150
            let id2: Int = instr % 150

            if (id1) != 0 {
                instructions.append(ActionInstruction(forGame: forGame, withId: id1))
            }

            if (id2) != 0 {
                instructions.append(ActionInstruction(forGame: forGame, withId: id2))
            }
        }

        Verb = verbNoun / 150
        Noun = verbNoun % 150
        Conditions = conds
        Instructions = instructions
        Args = args
    }
}

extension GameAction : CustomStringConvertible {

    // CustomStringConvcertible protocol implementation
    public var description: String {
        get {
            return "Verb: \(Verb), Noun: \(Noun)\r\n"
                + "   Conditions: \(Conditions)"
                + "   Instructions: \(Instructions)"
                + "   Args: \(Args)"
        }
    }
}

extension GameAction {

    public func execute(testChance: Bool) -> ActionExecutionResults {

        if !allConditionsAreTrue() {
            return .actFailedConditions
        }

        if testChance && Verb == 0 && Noun < 100 {
            // It's an occurrance and may be random ? whatever that means!
            let dice = arc4random_uniform(100)
            if dice >= Noun {
                return .actSuccess
            }
        }

        // Clone an array??? Need a copy for the instruction execute
        var argCopy = Args.map { $0 }

        var seenContinue = false
        for instruct in Instructions {
            let result = instruct.execute(&argCopy)
            seenContinue = seenContinue || result
        }

        return seenContinue ? .actContinue : .actSuccess
    }

    private func allConditionsAreTrue() -> Bool {
        for cond in Conditions {
            if !cond.evaluate() {
                return false
            }
        }

        return true
    }
}

public enum ActionExecutionResults {
    case actFailedConditions
    case actSuccess
    case actContinue
    case actNoMatch
}

