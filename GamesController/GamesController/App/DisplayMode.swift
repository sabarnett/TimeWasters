//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 10/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

/// DisplayMode
///
/// Determines whether we want to display in Light mode, Dark mode or let the app
/// mirror the current state of the Mac. We define this as Identifiable and CaseIterable
/// so it can be used to build selection lists. Equatable allows settings to be compared
/// and CustomStringConvertible gives us the text to display in pickers.
enum DisplayMode: String, Identifiable, CaseIterable, Equatable, CustomStringConvertible {
    case light
    case dark
    case auto

    var id: String {
        return self.description
    }

    var description: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .auto:
            return "Auto"
        }
    }
}
