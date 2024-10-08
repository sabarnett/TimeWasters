//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 12/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct Menus: Commands {
    var body: some Commands {
        SystemMenus()
        DisplayMenu()
    }
}

struct SystemMenus: Commands {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.appInfo) {
            Button("About \(Bundle.main.appName)") {
                appDelegate.showAboutWnd()
            }
        }
    }
}

struct DisplayMenu: Commands {
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .light
    
    var body: some Commands {
        CommandMenu("Display") {
            Picker(selection: $displayMode, content: {
                ForEach(DisplayMode.allCases) { mode in
                    Text(mode.description).tag(mode)
                }
            }, label: {
                Text("Display mode")
            })
        }
    }
}
