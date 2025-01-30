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
import SharedComponents

/// Creates the game button for the home page.
///
/// The game button consists of a rectangular button with a title and short title. To the
/// left will be a clock icon. When the user hovers over the clock, it transforms into
/// an info icon. When they move off the info icon, it reverts to a clock.
///
/// When the button is clicked, we call the padded in playGame function. If the user
/// clicks on the info button, we call the showInfo function.
///
/// When the button is created, it can be passed a timeDelay parameter. This is used to
/// introduce a short delay before the button becomes visible. The delay is the timeDelay
/// value time 0.3 seconds. By passing n increasing values for the timeDelay, you can
/// stagger the display of the buttons.
struct GameButton: View {
    @Environment(\.openWindow) private var openWindow

    let game: Game
    let gameIndex: Int
    var playGame: () -> Void
    var showInfo: () -> Void
    
    @State var buttonOpacity: Double = 0
    @State private var rotationClock: Angle = .degrees(0.0)
    @State private var rotationInfo: Angle = .degrees(90.0)

    var timeDelay: Double {
        Double(gameIndex) * 0.3
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Spacer().frame(width: 25, height: 1)
                    VStack(alignment: .leading) {
                        Text(game.title)
                            .font(.system(size: 16))
                            .bold()
                            .frame(minWidth: 200, maxWidth: 200,
                                   minHeight: 30, alignment: .leading)
                            .padding(.leading, 40)
                    }
                    .padding(.vertical, 3)
                    .foregroundStyle(.black.opacity(0.5))
                    .background { Image("banner")
                            .resizable()
                            .frame(maxHeight: 90)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        playGame()
                    }
                }
            }
            
            Image("clock-face")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 10)
                .rotation3DEffect(
                    rotationClock,
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            
            Image("clock-info")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.leading, 10)
                .onTapGesture {
                    showInfo()
                }
                .rotation3DEffect(
                    rotationInfo,
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .onHover(perform: { hovering in
                    if hovering {
                        withAnimation(.easeIn(duration: 0.3)) {
                            rotationClock = .degrees(90.0)
                        }
                        withAnimation(.easeIn(duration: 0.3).delay(0.3)) {
                            rotationInfo = .degrees(0.0)
                        }
                    } else {
                        withAnimation(.easeIn(duration: 0.3)) {
                            rotationInfo = .degrees(90.0)
                        }
                        withAnimation(.easeIn(duration: 0.3).delay(0.3)) {
                            rotationClock = .degrees(00.0)
                        }
                     }
                })
        }
        .opacity(buttonOpacity)
        .animation(.easeIn(duration: 1)
            .delay(TimeInterval(timeDelay)), value: buttonOpacity)
        .task {
            buttonOpacity = 1
        }
    }
}

#Preview {
    GameButton(game: Games().games[0],
               gameIndex: 0,
               playGame: { print("Play Game")},
               showInfo: { print("Show Info")})
}
