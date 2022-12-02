//
//  SSWindow.swift
//  Snapshot
//
//  Created by winddpan on 2022/9/18.
//

import Cocoa
import Combine
import KeyboardShortcuts

class SSWindow: NSWindow {
    @PassthroughSubjectErased var onExit: AnyPublisher<Void, Never>

    convenience init(contentRect: NSRect, screen: NSScreen?) {
        self.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false, screen: screen)

        self.acceptsMouseMovedEvents = true
        self.collectionBehavior = [.fullScreenAuxiliary, .canJoinAllSpaces]
        self.isMovableByWindowBackground = false
        self.isExcludedFromWindowsMenu = true
        self.alphaValue = 1.0
        self.isOpaque = false
        self.hasShadow = false
        self.hidesOnDeactivate = false
        self.isRestorable = false
        self.level = NSWindow.Level(2147483631)
        self.isMovable = false
        disableSnapshotRestoration()
    }

    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        if event.type == .keyDown,
           let s = KeyboardShortcuts.Shortcut(event: event),
           KeyboardShortcuts.Name.esc.shortcut == s
        {
            _onExit.send(())
        }
    }

    private func mousePoint(_ event: NSEvent) -> CGPoint? {
        if let convertedPoint = contentView?.convert(event.locationInWindow, from: nil) {
            return CGPoint(x: convertedPoint.x, y: convertedPoint.y)
        }
        return nil
    }

    override func rightMouseUp(with event: NSEvent) {
        _onExit.send(())
    }
}
