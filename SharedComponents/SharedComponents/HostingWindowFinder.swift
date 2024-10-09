//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 08/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct HostingWindowFinder: NSViewRepresentable {
    var callback: (NSWindow?) -> Void
    
    public init(callback: @escaping (NSWindow?) -> Void) {
        self.callback = callback
    }
    
    public func makeNSView(context: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) {}
}
