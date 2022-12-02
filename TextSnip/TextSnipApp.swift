//
//  TextSnipApp.swift
//  TextSnip
//
//  Created by PAN on 2022/11/29.
//

import SwiftUI

@main
struct TextSnipApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    let snapshotManager: SnapshotManager

    init() {
        snapshotManager = SnapshotManager()
        appDelegate.snapshotManager = snapshotManager
    }

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    var snapshotManager: SnapshotManager!

    func applicationDidFinishLaunching(_ notification: Notification) {
        createMenu()
    }

    func applicationDidBecomeActive(_ notification: Notification) {}

    private func createMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        guard let statusBarButton = statusItem.button else { return }
        statusBarButton.image = NSImage(named: "StatusIcon")

        let mainMenu = NSMenu()

        let startCaptureItem = NSMenuItem()
        startCaptureItem.title = NSLocalizedString("Start captrue", comment: "")
        startCaptureItem.target = self
        startCaptureItem.action = #selector(startCapture)
        startCaptureItem.setShortcut(for: .startCapture)
        mainMenu.addItem(startCaptureItem)

        let perferenceItem = NSMenuItem()
        perferenceItem.title = NSLocalizedString("Perference", comment: "")
        perferenceItem.target = self
        perferenceItem.action = #selector(openPerference)
        mainMenu.addItem(perferenceItem)

        let quitItem = NSMenuItem()
        quitItem.title = NSLocalizedString("Quit", comment: "")
        quitItem.target = self
        quitItem.action = #selector(quit)
        mainMenu.addItem(quitItem)

        statusItem.menu = mainMenu
    }

    @objc private func startCapture() {
        snapshotManager.startCapture()
    }

    @objc private func openPerference() {}

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
