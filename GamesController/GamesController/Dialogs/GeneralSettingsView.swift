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
    @ObservedObject var settings: SettingsViewModel
    
    var body: some View {
        Form {
            Picker("Display mode", selection: $settings.displayMode) {
                ForEach(DisplayMode.allCases) { mode in
                    Text(mode.description).tag(mode)
                }
            }
            
            Toggle(isOn: $settings.closeAppWhenLastWindowCloses,
                   label: { Text("Close the app when the last window closes.")})
        }
        .padding()
    }
}

#Preview {
    GeneralSettingsView(settings: SettingsViewModel())
}
