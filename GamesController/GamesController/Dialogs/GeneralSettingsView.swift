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

struct GeneralSettingsView: View {
    @AppStorage(Constants.autoCloseApp) var closeAppWhenLastWindowCloses: Bool = true
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .auto

    var body: some View {
        Form {
            Picker("Display mode", selection: $displayMode) {
                ForEach(DisplayMode.allCases) { mode in
                    Text(mode.description).tag(mode)
                }
            }
            .frame(maxWidth: 350)
            
            Toggle(isOn: $closeAppWhenLastWindowCloses,
                   label: { Text("Close the app when the last window closes.")})
        }
        .padding()
    }
}

#Preview {
    GeneralSettingsView()
}
