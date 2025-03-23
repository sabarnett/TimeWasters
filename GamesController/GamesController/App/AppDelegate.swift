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

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @AppStorage("closeAppWhenLastWindowCloses") var closeAppWhenLastWindowCloses: Bool = true

    private var aboutBoxWindowController: NSWindowController?
    
    /// Shows our custom about box. This is a complete replacement for the
    /// built in about box, allowing us a lot of customisation options.
    @MainActor
    func showAboutWnd() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "About \(Bundle.main.appName)"
            window.contentView = NSHostingView(rootView: AboutView())
            window.center()
            aboutBoxWindowController = NSWindowController(window: window)
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
    
    /// The user can elect to close the app when the last data window closes or to leave the
    /// app open so they can open another file.
    ///
    /// - Returns: True if we should close the app else false.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return closeAppWhenLastWindowCloses
    }
}
