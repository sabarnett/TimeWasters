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

import Foundation

enum EvaluationErrors: Error {
    case invalidCharacter(char: Character)
    case unknownOperator(op: Character)
    case divideByZero
    case unexpectedToken
    case incompleteFormula
}

struct FormulaEvaluator {
    
    private enum Token: Equatable {
        case number(Int)
        case operatorSymbol(Character)
        case leftParenthesis
        case rightParenthesis
    }
    
    public func evaluate(expression: String) throws -> Int {
        let tokens = try tokenize(expression: expression)
        let postfixTokens = infixToPostfix(tokens: tokens)
        return try evaluatePostfix(postfixTokens)
    }
    
    private func tokenize(expression: String) throws -> [Token] {
        var tokens = [Token]()
        var currentNumber = ""
        
        for char in expression {
            if char.isNumber || char == "." {
                currentNumber.append(char)
            } else {
                if !currentNumber.isEmpty {
                    tokens.append(.number(Int(currentNumber)!))
                    currentNumber = ""
                }
                
                switch char {
                case "+", "-", "*", "/":
                    tokens.append(.operatorSymbol(char))
                case "(":
                    tokens.append(.leftParenthesis)
                case ")":
                    tokens.append(.rightParenthesis)
                case " ":
                    continue  // Ignore spaces
                default:
                    throw EvaluationErrors.invalidCharacter(char: char)
                }
            }
        }
        
        // Add the last collected number if any
        if !currentNumber.isEmpty {
            tokens.append(.number(Int(currentNumber)!))
        }
        
        return tokens
    }
    
    private func precedence(of operatorSymbol: Character) -> Int {
        switch operatorSymbol {
        case "+", "-":
            return 1
        case "*", "/":
            return 2
        default:
            return 0
        }
    }
    
    private func infixToPostfix(tokens: [Token]) -> [Token] {
        var outputQueue = [Token]()
        var operatorStack = [Token]()

        for token in tokens {
            switch token {
            case .number:
                outputQueue.append(token)
            case .operatorSymbol(let op):
                while let last = operatorStack.last, case .operatorSymbol(let lastOp) = last,
                      precedence(of: lastOp) >= precedence(of: op) {
                    outputQueue.append(operatorStack.popLast()!)
                }
                operatorStack.append(token)
            case .leftParenthesis:
                operatorStack.append(token)
            case .rightParenthesis:
                while let last = operatorStack.last,
                        last != .leftParenthesis {
                    outputQueue.append(operatorStack.popLast()!)
                }
                let _ = operatorStack.popLast()  // Remove the left parenthesis
            }
        }
        
        while let last = operatorStack.popLast() {
            outputQueue.append(last)
        }
        
        return outputQueue
    }
    
    private func evaluatePostfix(_ tokens: [Token]) throws -> Int {
        var stack = [Int]()

        for token in tokens {
            switch token {
            case .number(let value):
                stack.append(value)
            case .operatorSymbol(let op):
                guard let right = stack.popLast() else { throw EvaluationErrors.incompleteFormula }
                guard let left = stack.popLast() else { throw EvaluationErrors.incompleteFormula }
                let result: Int
                switch op {
                case "+":
                    result = left + right
                case "-":
                    result = left - right
                case "*":
                    result = left * right
                case "/":
                    if right == 0 { throw EvaluationErrors.divideByZero }
                    result = left / right
                default:
                    throw EvaluationErrors.unknownOperator(op: op)
                }
                stack.append(result)
            default:
                throw EvaluationErrors.unexpectedToken
            }
        }

        return stack.popLast()!
    }
}
