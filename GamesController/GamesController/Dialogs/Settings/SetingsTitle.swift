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

struct SettingsTitle: View {
    
    var systemImage: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                
            Text(title)
            Spacer()
        }
        .font(.title)
        .padding()
        .foregroundStyle(Color.accentColor)

    }
}
