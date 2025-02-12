// swiftlint:disable file_length
//
//  BHBezelNotification.swift
//  BH Bezel Notification
//
//  Created by Ben Leggiero on 2017-11-09.
//  Copyright © 2017 Ben Leggiero. All rights reserved.
//

import Cocoa
import Foundation
import AppKit

/// All currently-showing bezel windows
private var bezelWindows = Set<BHBezelWindow>()

/// The Cocoa-style public interface for showing a notification bezel
enum BezelNotification {
    // Empty on-purpose; all members are static
}

extension BezelNotification {
    
    /// Shows a BHBezel notification using the given parameters.
    /// See `BHBezelParameters` for documentation of each parameter.
    ///
    /// If you want to manually dismiss th enotification, rather than trusting the time to live, you can give a very
    /// large nubmer for `timeToLive` and call the resulting delegate's `donePresentingBezel()` function.
    ///
    /// - Returns: A delegate that allows control of the bezel after it's shown
    /// - SeeAlso: BHBezelParameters
    @discardableResult
    static func show(messageText: String,
                     icon: NSImage? = nil,
                     
                     location: BezelLocation = BezelParameters.defaultLocation,
                     size: BezelSize = BezelParameters.defaultSize,
                     
                     timeToLive: BezelTimeToLive = BezelParameters.defaultTimeToLive,
                     fadeInAnimationDuration: TimeInterval = BezelParameters.defaultFadeInAnimationDuration,
                     fadeOutAnimationDuration: TimeInterval = BezelParameters.defaultFadeOutAnimationDuration,
                     
                     cornerRadius: CGFloat = BezelParameters.defaultCornerRadius,
                     tint: NSColor = BezelParameters.defaultBackgroundTint,
                     messageLabelFont: NSFont = BezelParameters.defaultMessageLabelFont,
                     messageLabelColor: NSColor = BezelParameters.defaultMessageLabelColor
    ) -> BezelDelegate {
        
        return self.show(
            with: BezelParameters(
                messageText: messageText,
                icon: icon,
                
                location: location,
                size: size,
                
                timeToLive: timeToLive,
                fadeInAnimationDuration: fadeInAnimationDuration,
                fadeOutAnimationDuration: fadeOutAnimationDuration,
                
                cornerRadius: cornerRadius,
                backgroundTint: tint,
                messageLabelFont: messageLabelFont,
                messageLabelColor: messageLabelColor
            ))
    }
    
    /// Shows a BHBezel notification using the given parameters.
    /// See `BHBezelParameters` for documentation of each parameter.
    ///
    /// If you want to manually dismiss th enotification, rather than trusting the time to live, you can give a very
    /// large nubmer for `timeToLive` (e.g. `.infinity`) and call the resulting delegate's `donePresentingBezel()`
    /// function.
    ///
    /// - Returns: A delegate that allows control of the bezel after it's shown
    /// - SeeAlso: BHBezelParameters
    static func show(with parameters: BezelParameters
    ) -> BezelDelegate {
        
        let bezelWindow = BHBezelWindow(parameters: parameters)
        bezelWindows.insert(bezelWindow)
        
        class BHBezelDelegateImpl: BezelDelegate {
            
            var shouldFadeOut = true
            weak var bezelWindow: BHBezelWindow?
            
            init(bezelWindow: BHBezelWindow) {
                self.bezelWindow = bezelWindow
            }
            
            func donePresentingBezel() {
                guard
                    shouldFadeOut,
                    let bezelWindow = bezelWindow
                else { return }
                
                shouldFadeOut = false
                
                bezelWindow.fadeOut(sender: nil,
                                    duration: bezelWindow.parameters.fadeOutAnimationDuration,
                                    closeSelector: .close) {
                    bezelWindows.remove(bezelWindow)
                }
            }
        }
        
        let delegate = BHBezelDelegateImpl(bezelWindow: bezelWindow)
        
        bezelWindow.fadeIn(sender: nil,
                           duration: parameters.fadeInAnimationDuration,
                           presentationFunction: .orderFrontRegardless)
        
        Timer.scheduledTimer(withTimeInterval: parameters.timeToLive.inSeconds, repeats: false) { _ in
            delegate.donePresentingBezel()
        }
        
        return delegate
    }
}

/// Use this to interact with a bezel after it's been shown
protocol BezelDelegate: AnyObject {
    /// Called when the bezel is done and should be faded out, closed, and destroyed.
    /// This is useful for hiding it early or manually.
    func donePresentingBezel()
}

/// A set of parameters used to configure and present a bezel notification
struct BezelParameters {
    
    public static let defaultLocation: BezelLocation = .normal
    public static let defaultSize: BezelSize = .normal
    public static let defaultTimeToLive: BezelTimeToLive = .short
    
    public static let defaultFadeInAnimationDuration: TimeInterval = 0
    public static let defaultFadeOutAnimationDuration: TimeInterval = 0.25
    
    public static let defaultCornerRadius: CGFloat = 18
    public static let defaultBackgroundTint = NSColor(calibratedWhite: 0, alpha: 1)
    // swiftlint:disable:next identifier_name
    public static let defaultMessageLabelBaselineOffsetFromBottomOfBezel: CGFloat = 20
    public static let defaultMessageLabelFontSize: CGFloat = 18
    public static let defaultMessageLabelFont = NSFont.systemFont(ofSize: defaultMessageLabelFontSize)
    public static let defaultMessageLabelColor = NSColor.labelColor
    
    // MARK: Basics
    
    /// The text to show in the bezel notification's message area
    let messageText: String
    
    /// The icon to show in the bezel notification's icon area
    let icon: NSImage?
    
    // MARK: Presentation
    
    /// The location on the screen at which to display the bezel notification
    let location: BezelLocation
    
    /// The size of the bezel notification
    let size: BezelSize
    
    /// The number of seconds to display the bezel notification on the screen
    let timeToLive: BezelTimeToLive
    
    // MARK: Animations
    
    /// The number of seconds that it takes to fade in the bezel notification
    let fadeInAnimationDuration: TimeInterval
    
    /// The number of seconds that it takes to fade out the bezel notification
    let fadeOutAnimationDuration: TimeInterval
    
    // MARK: Drawing
    
    /// The radius of the bezel notification's corners, in points
    let cornerRadius: CGFloat
    
    /// The tint of the bezel notification's background
    let backgroundTint: NSColor
    
    /// The distance from the bottom of the bezel notification's bottom at which the baseline of the message label sits
    let messageLabelBaselineOffsetFromBottomOfBezel: CGFloat
    // swiftlint:disable:previous identifier_name
    
    /// The font used for the message label
    let messageLabelFont: NSFont
    
    /// The text color of the message label
    let messageLabelColor: NSColor
    
    init(messageText: String,
         icon: NSImage? = nil,
         
         location: BezelLocation = defaultLocation,
         size: BezelSize = defaultSize,
         timeToLive: BezelTimeToLive = defaultTimeToLive,
         
         fadeInAnimationDuration: TimeInterval = defaultFadeInAnimationDuration,
         fadeOutAnimationDuration: TimeInterval = defaultFadeOutAnimationDuration,
         
         cornerRadius: CGFloat = defaultCornerRadius,
         backgroundTint: NSColor = defaultBackgroundTint,
         // swiftlint:disable:next identifier_name
         messageLabelBaselineOffsetFromBottomOfBezel: CGFloat = defaultMessageLabelBaselineOffsetFromBottomOfBezel,
         messageLabelFont: NSFont = defaultMessageLabelFont,
         messageLabelColor: NSColor = defaultMessageLabelColor
    ) {
        self.messageText = messageText
        self.icon = icon
        
        self.location = location
        self.size = size
        self.timeToLive = timeToLive
        
        self.fadeInAnimationDuration = fadeInAnimationDuration
        self.fadeOutAnimationDuration = fadeOutAnimationDuration
        
        self.cornerRadius = cornerRadius
        self.backgroundTint = backgroundTint.withAlphaComponent(0.15)
        self.messageLabelBaselineOffsetFromBottomOfBezel = messageLabelBaselineOffsetFromBottomOfBezel
        self.messageLabelFont = messageLabelFont
        self.messageLabelColor = messageLabelColor
    }
}

/// How long a bezel notification should stay on screen
enum BezelTimeToLive {
    /// Bezel is shown for just a couple seconds
    case short
    
    /// Bezel if shown for several seconds
    case long
    
    /// Bezel is never hidden
    case forever
    
    /// Bezel is shown for an exact number of seconds
    case exactly(seconds: TimeInterval)
    
    var inSeconds: TimeInterval {
        switch self {
        case .short: return 2
        case .long: return 6
        case .forever: return .infinity
        case .exactly(let seconds): return seconds
        }
    }
}

/// The window used to present a bezel notification.
/// If you _really_ need minute control, you may use this.
class BHBezelWindow: NSWindow {
    
    private lazy var bezelContentView: BHBezelContentView = {
        let bezelContentView = BHBezelContentView(parameters: self.parameters)
        bezelContentView.wantsLayer = true
        bezelContentView.layer?.backgroundColor = parameters.backgroundTint.cgColor
        return bezelContentView
    }()
    
    var messageText: String { return parameters.messageText }
    
    fileprivate let parameters: BezelParameters
    
    /// Creates a new bezel window with the given parameters
    ///
    /// - Parameter parameters: Those parameters that dictate how this window appears
    init(parameters: BezelParameters) {
        
        self.parameters = parameters
        
        let contentRect = parameters.location.bezelWindowContentRect(atSize: parameters.size)
        
        super.init(contentRect: contentRect,
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: false)
        
        contentView = makeVisualEffectsBackingView()
        
        self.minSize = contentRect.size
        self.maxSize = contentRect.size
        
        self.isReleasedWhenClosed = false
        self.level = .modalPanel // = .dock
        self.ignoresMouseEvents = true
        self.appearance = NSAppearance(named: .vibrantDark)
        self.isOpaque = false
        self.backgroundColor = .clear
        
        addComponents()
    }
    
    private func addComponents() {
        guard let contentView = self.contentView else {
            assertionFailure("No content view when adding components to bezel!!")
            return
        }
        
        contentView.wantsLayer = true
        
        contentView.addSubview(bezelContentView)
        NSLayoutConstraint.activate([
            bezelContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bezelContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bezelContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bezelContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func makeVisualEffectsBackingView() -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.wantsLayer = true
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.maskImage = .roundedRectMask(size: self.parameters.size.cgSize,
                                                      cornerRadius: self.parameters.cornerRadius)
        return visualEffectView
    }
}

/// The view powering the `BHBezelWindow`'s appearance.
/// If you _really, really_ need _extreme_ control, you may use this. Don't, though, if you can avoid it.
class BHBezelContentView: NSView {
    
    let parameters: BezelParameters
    
    override public var allowsVibrancy: Bool { return true }
    
    public init(parameters: BezelParameters) {
        self.parameters = parameters
        super.init(frame: NSRect(origin: .zero, size: parameters.size.cgSize))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        let textBounds = parameters.messageText.findBezelLabelBoundingBox(
            within: bounds,
            offsetFromBottom: parameters.messageLabelBaselineOffsetFromBottomOfBezel,
            font: parameters.messageLabelFont
        )
        
        if let icon = parameters.icon {
            let bezelSize = parameters.size.cgSize
            let bezelBounds = NSRect(origin: .zero, size: bezelSize)
            let bezelCenterX = bezelBounds.midX
            let messageLabelTop = textBounds.maxY
            let halfwayBetweenLabelTopAndBezelTop = (bezelBounds.maxY + messageLabelTop) / 2
            
            let iconSize = NSSize(scaling: icon.size,
                                  toFitWithin: bezelSize * 0.6,
                                  approach: .scaleProportionallyDown)
            
            let iconBottomLeftCorner = NSPoint(x: bezelCenterX - (iconSize.width / 2),
                                               y: halfwayBetweenLabelTopAndBezelTop - (iconSize.height / 2))
            
            icon.draw(
                in: NSRect(origin: iconBottomLeftCorner, size: iconSize),
                from: .zero, // This is a "magic value" meaning "draw the whole image"
                operation: .sourceOver,
                fraction: 1, // "fraction" = "opacity"
                respectFlipped: true,
                hints: [.interpolation: NSNumber(value: NSImageInterpolation.high.rawValue)]
            )
        }
        
        context.setTextDrawingMode(.fill)
        context.draw(text: parameters.messageText,
                     at: textBounds.origin,
                     color: parameters.messageLabelColor.withAlphaComponent(parameters.messageLabelColor.alphaComponent * 0.8),
                     font: parameters.messageLabelFont)
    }
}

private extension String {
    func findBezelLabelBoundingBox(within parentBounds: NSRect,
                                   offsetFromBottom: CGFloat,
                                   font: NSFont) -> NSRect {
        let attributedString = NSAttributedString(string: self, attributes: [.font: font])
        let textBounds = attributedString.boundingRect(with: parentBounds.size, options: [])
        let textBaselineY = offsetFromBottom
        let textLeftX = parentBounds.midX - textBounds.midX
        return NSRect(origin: NSPoint(x: textLeftX, y: textBaselineY), size: textBounds.size)
    }
    
    func findBezelLabelTextStartPoint(within parentBounds: NSRect,
                                      offsetFromBottom: CGFloat,
                                      font: NSFont) -> NSPoint {
        return findBezelLabelBoundingBox(within: parentBounds, offsetFromBottom: offsetFromBottom, font: font).origin
    }
}

/// The semantic size of a bezel notification
public enum BezelSize {
    case normal
    case wide
}

extension BezelSize {
    
    private var width: CGFloat {
        switch self {
        case .normal:
            return 200
        case .wide:
            return 350
        }
    }
    
    private var height: CGFloat {
        switch self {
        case .normal:
            return 200
        case .wide:
            return 200
        }
    }
    
    var cgSize: CGSize {
        CGSize(width: width, height: height)
    }
}

/// The semantic location of a bezel notification
enum BezelLocation {
    case normal
}

extension BezelLocation {
    
    func bezelWindowContentRect(atSize size: BezelSize) -> NSRect {
        switch self {
        case .normal:
            return screen?.lowerCenterRect(ofSize: size.cgSize) ?? NSRect(origin: NSPoint(x: 48, y: 48), size: size.cgSize)
        }
    }
    
    var screen: NSScreen? {
        switch self {
        case .normal:
            return .main ?? NSScreen.screens.first
        }
    }
}

private extension NSScreen {
    
    private static let lowerCenterRectBottomOffset: CGFloat = 140
    
    func lowerCenterRect(ofSize size: NSSize) -> NSRect {
        return NSRect(origin: NSPoint(x: self.frame.midX - (size.width / 2),
                                      y: self.frame.minY + NSScreen.lowerCenterRectBottomOffset),
                      size: size)
    }
}

private let defaultWindowAnimationDuration: TimeInterval = 0.25

internal extension NSWindow {
    
    /// Called when an animation completes
    typealias AnimationCompletionHandler = () -> Void
    
    /// Represents a function called to make a window be presented
    enum PresentationFunction {
        /// Calls `NSWindow.makeKey()`
        case makeKey
        
        /// Calls `NSWindow.makeKeyAndOrderFront(_:)`
        case makeKeyAndOrderFront
        
        /// Calls `NSWindow.orderFront(_:)`
        case orderFront
        
        /// Calls `NSWindow.orderFrontRegardless()`
        case orderFrontRegardless
        
        /// Runs the function represented by this case on the given window, passing the given selector if needed
        func run(on window: NSWindow, sender: Any? = nil) {
            switch self {
            case .makeKey: window.makeKey()
            case .makeKeyAndOrderFront: window.makeKeyAndOrderFront(sender)
            case .orderFront: window.orderFront(sender)
            case .orderFrontRegardless: window.orderFrontRegardless()
            }
        }
    }
    
    /// Represents a function called to make a window be closed
    enum CloseFunction {
        
        /// Calls `NSWindow.orderOut(_:)`
        case orderOut
        
        /// Calls `NSWindow.close()`
        case close
        
        /// Calls `NSWindow.performClose()`
        case performClose
        
        /// Runs the function represented by this case on the given window, passing the given selector if needed
        func run(on window: NSWindow, sender: Any? = nil) {
            switch self {
            case .orderOut: window.orderOut(sender)
            case .close: window.close()
            case .performClose: window.performClose(sender)
            }
        }
    }
    
    /// Fades this window in using the given configuration
    ///
    /// - Parameters:
    ///   - sender:               The message's sender, if any
    ///   - duration:             The minimum amount of time it should to fade the window in
    ///   - timingFunction:       The timing function of the animation
    ///   - startingAlpha:        The alpha value at the start of the animation
    ///   - targetAlpha:          The alpha value at the end of the animation
    ///   - presentationFunction: The function to use when initially presenting the window
    ///   - completionHandler:    Called when the animation completes
    func fadeIn(sender: Any? = nil,
                duration: TimeInterval = defaultWindowAnimationDuration,
                timingFunction: CAMediaTimingFunction? = .default,
                startingAlpha: CGFloat = 0,
                targetAlpha: CGFloat = 1,
                presentationFunction: PresentationFunction = .makeKeyAndOrderFront,
                completionHandler: AnimationCompletionHandler? = nil) {
        
        alphaValue = startingAlpha
        
        presentationFunction.run(on: self, sender: sender)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.timingFunction = timingFunction
            animator().alphaValue = targetAlpha
        }, completionHandler: completionHandler)
    }
    
    /// Fades this window out using the given configuration
    ///
    /// - Note: Unlike `fadeIn`, this does not take a starting alpha value. This is because the window's current
    ///         alpha is used. If you really want it to be different, simply change that immediately before calling
    ///         this function.
    ///
    /// - Parameters:
    ///   - sender:               The message's sender, if any
    ///   - duration:             The minimum amount of time it should to fade the window out
    ///   - timingFunction:       The timing function of the animation
    ///   - targetAlpha:          The alpha value at the end of the animation
    ///   - presentationFunction: The function to use when initially presenting the window
    ///   - completionHandler:    Called when the animation completes
    func fadeOut(sender: Any? = nil,
                 duration: TimeInterval = defaultWindowAnimationDuration,
                 timingFunction: CAMediaTimingFunction? = .default,
                 targetAlpha: CGFloat = 0,
                 resetAlphaAfterAnimation: Bool = true,
                 closeSelector: CloseFunction = .orderOut,
                 completionHandler: AnimationCompletionHandler? = nil) {
        
        let startingAlpha = self.alphaValue
        
        NSAnimationContext.runAnimationGroup({ context in
            
            context.duration = duration
            context.timingFunction = timingFunction
            animator().alphaValue = targetAlpha
            
        }, completionHandler: { [weak weakSelf = self] in
            guard let weakSelf = weakSelf else { return }
            
            closeSelector.run(on: weakSelf, sender: sender)
            
            if resetAlphaAfterAnimation {
                weakSelf.alphaValue = startingAlpha
            }
            
            completionHandler?()
        })
    }
}

extension CAMediaTimingFunction {
    static let easeIn = CAMediaTimingFunction(name: .easeIn)
    static let easeOut = CAMediaTimingFunction(name: .easeOut)
    static let easenInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)
    static let linear = CAMediaTimingFunction(name: .linear)
    static let `default` = CAMediaTimingFunction(name: .default)
}

internal extension NSImage {
    static func roundedRectMask(size: NSSize, cornerRadius: CGFloat) -> NSImage {
        
        let maskImage = NSImage(size: size, flipped: false) { rect in
            let bezierPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            NSColor.black.set()
            bezierPath.fill()
            return true
        }
        
        maskImage.capInsets = NSEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        maskImage.resizingMode = .stretch
        
        return maskImage
    }
}

internal extension CGSize {
    
    init(scaling original: CGSize, toFitWithin parent: CGSize, approach: NSImageScaling) {
        
        switch approach {
        case .scaleAxesIndependently:
            self = parent
            
        case .scaleNone:
            self = original
            
        case .scaleProportionallyDown:
            // If it already fits, no need to scale. Just use the original.
            if original.height < parent.height
                && original.width < parent.width {
                self = original
            } else {
                fallthrough
            }
            
        case .scaleProportionallyUpOrDown:
            let tooManyPixelsTall = max(0, original.height - parent.height)
            let tooManyPixelsWide = max(0, original.width - parent.width)
            
            let shouldScaleToFitHeight = tooManyPixelsTall > tooManyPixelsWide
            
            if shouldScaleToFitHeight {
                self.init(scaling: original, proportionallyToFitHeight: parent.height)
            } else {
                self.init(scaling: original, proportionallyToFitWidth: parent.width)
            }
            
        @unknown default:
            self = original
        }
    }
    
    init(scaling original: CGSize, proportionallyToFitHeight newHeight: CGFloat) {
        let percentChange = newHeight / original.height
        self.init(width: original.width * percentChange,
                  height: newHeight)
    }
    
    init(scaling original: CGSize, proportionallyToFitWidth newWidth: CGFloat) {
        let percentChange = newWidth / original.width
        self.init(width: newWidth,
                  height: original.height * percentChange)
    }
    
    var aspectRatio: CGFloat {
        return width / height
    }
}

internal extension CGSize {
    static func * (lhs: Double, rhs: CGSize) -> CGSize {
        return CGFloat(lhs) * rhs
    }
    
    static func * (lhs: CGSize, rhs: Double) -> CGSize {
        return lhs * CGFloat(rhs)
    }
    
    static func * (lhs: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs * rhs.width,
                      height: lhs * rhs.height)
    }
    
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs,
                      height: lhs.height * rhs)
    }
    
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width,
                      height: lhs.height * rhs.height)
    }
}

extension CGContext {
    func draw(text string: String,
              at point: CGPoint,
              color: NSColor,
              font: NSFont = .systemFont(ofSize: NSFont.systemFontSize)) {
        (string as NSString).draw(at: point,
                                  withAttributes: [
                                    .foregroundColor: color,
                                    .font: font
                                  ])
    }
}
// swiftlint:enable file_length
