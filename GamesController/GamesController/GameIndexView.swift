//
// -----------------------------------------
// Original project: GamesController
// Original package: GamesController
// Created on: 09/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

struct GameIndexView: View {
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var gameList: Games
    
    @State var selectedGame: Game?
    @State var showInfo: Bool = false
    
    @State private var buttonsVisible = false
    private var columns: [GridItem] { Array.init(repeating: GridItem(), count: 2) }
    private var games: [Game] { gameList.games }
    
    @State private var imageId: UUID = UUID()
    
    var body: some View {
        ZStack {
            Image("bgImage")
                .resizable()
                .frame(width: 800, height: 460)
                .ignoresSafeArea()

            VStack {
                Spacer()
                    .frame(height: 100)
                
                ScrollView(.vertical) {
                    VStack {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(games) { game in
                                let gameIndex = games.firstIndex(of: game)!
                                GameButton(
                                    game: game,
                                    gameIndex: gameIndex,
                                    playGame: {
                                       openWindow(id: game.id, value: game)
                                 }, showInfo: {
                                    selectedGame = game
                                    showInfo = true
                                })
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                HStack {
                    Button(action: {
                        NSApp.terminate(nil)
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .imageScale(.medium)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.white)
                    })
                    .buttonStyle(.plain)
                    
                    Spacer()
                    SettingsLink(label: {
                        Image(systemName: "gear")
                            .resizable()
                            .imageScale(.medium)
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.white)
                    })
                    .buttonStyle(.plain)
                }.padding()
            }
            .padding()
            
            HostingWindowFinder { win in
                guard let win else { return }
                setAttributes(window: win)
            }
            .frame(height: 0)
        }
        // Temp code to reload the view. This just makes it easier
        // when I want to record a video of the opening screen for
        // the web site and for github. It serves no other purpose.
        .id(imageId)
        .onTapGesture {
            imageId = UUID()
        }

        .sheet(item: $selectedGame) { game in
            GameInfo(gameData: game)
        }

        .frame(width: 800, height: 417)
        .presentedWindowStyle(.hiddenTitleBar)
    }
    
    /// Sets the home screen attributes. We are looking to create a window with
    ///
    /// * No close/minimize/zoom buttons
    /// * Has no title or title bar
    /// * Can be moved (since there is no title bar) by dragging the background.
    ///
    /// - Parameter window: The NSWindow reference of our main window.
    private func setAttributes(window: NSWindow) {
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.isMovableByWindowBackground = true
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
    }
}

#Preview {
    GameIndexView()
        .environmentObject(Games())
}
