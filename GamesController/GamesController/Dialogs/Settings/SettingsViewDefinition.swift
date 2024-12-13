//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 13/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct SettingViewDefinition: ViewModifier {
    
    var title: String
    var icon: String
    
    func body(content: Content) -> some View {
        ScrollView {
            SettingsTitle(systemImage: icon, title: title)
            content
        }
    }
}

extension View {
    func settingsViewDefinition(title: String, icon: String) -> some View {
        modifier(SettingViewDefinition(title: title, icon: icon))
    }
}
