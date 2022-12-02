//
//  SnapshotManager.swift
//  Snapshot
//
//  Created by PAN on 2022/9/19.
//

import Cocoa
import Combine
import Foundation
import KeyboardShortcuts
import SwiftUI
import VisionKit

class SnapshotManager {
    private var window: NSWindow?

    init() {
        KeyboardShortcuts.onKeyDown(for: .esc) { [weak self] in
            guard let self = self else { return }
            self.exitCapture()
        }

        KeyboardShortcuts.onKeyDown(for: .startCapture) { [weak self] in
            guard let self = self else { return }
            if self.window != nil {
                self.exitCapture()
                DispatchQueue.main.async {
                    self.startCapture()
                }
            } else {
                self.startCapture()
            }
        }
    }

    func startCapture() {
        guard let focusScreen = NSScreen.currentScreenForMouseLocation() else {
            return
        }
        guard let snapshotImage = CGWindowListCreateImage(focusScreen.frame.screenRect, .optionOnScreenOnly, kCGNullWindowID, .bestResolution) else {
            return
        }

        let screenRect = NSRect(x: 0, y: 0, width: focusScreen.frame.width, height: focusScreen.frame.height)
        let window = SSWindow(contentRect: screenRect, screen: focusScreen)
        self.window = window

        let snipView = SnipView(viewModel: .init(screenImage: NSImage(cgImage: snapshotImage, size: focusScreen.frame.size)),
                                onExit: { [weak self] in
                                    guard let self = self else { return }
                                    self.exitCapture()
                                })

        window.onExit.sink { [weak self] _ in
            guard let self = self else { return }
            self.exitCapture()
        }
        .store(in: self)

        let snipViewController = NSHostingController(rootView: snipView)
        let controller = NSWindowController(window: window)
        controller.contentViewController = snipViewController
        controller.showWindow(nil)

        window.becomeKey()
        controller.contentViewController?.becomeFirstResponder()
    }

    func exitCapture() {
        window?.close()
        window = nil
    }
}
