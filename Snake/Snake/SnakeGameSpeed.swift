//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 15/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

enum SnakeGameSpeed: Int, CustomStringConvertible, CaseIterable, Identifiable {
    case slow = 1
    case medium = 2
    case fast = 3
    
    var id: Int { rawValue }
    
    var description: String {
        switch self {
        case .slow: return "Slow"
        case .medium: return "Medium"
        case .fast: return "Fast"
        }
    }
}
