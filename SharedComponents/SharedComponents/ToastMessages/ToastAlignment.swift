//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 29/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//


import SwiftUI

public enum ToastAlignment {
    case top, bottom
    
    public var edge: Edge {
        get {
            switch self {
            case .top:
                Edge.top
            case .bottom:
                Edge.bottom
            }
        }
    }
    
    public var alignment: Alignment {
        get {
            switch self {
            case .top:
                Alignment.top
            case .bottom:
                Alignment.bottom
            }
        }
    }
}
