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

import SwiftUI

class SettingsViewModel: ObservableObject {

    // General tab options
    @AppStorage(Constants.autoCloseApp) var closeAppWhenLastWindowCloses: Bool = true
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .auto
}
