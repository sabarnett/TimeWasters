//
// -----------------------------------------
// Original project: MineSweeper
// Original package: MineSweeper
// Created on: 17/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct MinesweeperSettings: View {
    
    @AppStorage("cellCount") private var cellCount = 10
    @AppStorage("mineCount") private var mineCount = 10
    @AppStorage("minePlaySounds") private var minePlaySounds = true

    public init() { }
    
    public var body: some View {
        Form {
            HStack {
                Stepper("Grid size",
                        value: $cellCount,
                    in: 8...25,
                    step: 1
                )
                Text("\(cellCount.formatted()) cells")
            }
            .padding(.bottom, 12)
            
            HStack {
                Stepper("Mine count",
                        value: $mineCount,
                    in: 10...99,
                    step: 1
                )
                Text("\(mineCount.formatted()) mines")
            }
            .padding(.bottom, 12)
            
            Toggle("Play Sounds", isOn: $minePlaySounds)
        }
        .padding()
    }
}

#Preview {
    MinesweeperSettings()
}
