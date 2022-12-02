//
//  SwiftUI+OpenNewWindow.swift
//  TextSnip
//
//  Created by PAN on 2022/12/2.
//

import SwiftUI

extension View {
    private func newWindowInternal(title: String, geometry: NSRect, style: NSWindow.StyleMask, delegate: NSWindowDelegate?) -> NSWindow {
        let window = NSWindow(
            contentRect: geometry,
            styleMask: style,
            backing: .buffered,
            defer: false)
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        window.delegate = delegate
        return window
    }

    func openNewWindow(title: String, geometry: NSRect, style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable], delegate: NSWindowDelegate? = nil) {
        self.newWindowInternal(title: title, geometry: geometry, style: style, delegate: delegate).contentView = NSHostingView(rootView: self)
    }
}
