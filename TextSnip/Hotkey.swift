//
//  Hotkey.swift
//  Snapshot
//
//  Created by PAN on 2022/9/19.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name: CaseIterable {
    public static var allCases: [KeyboardShortcuts.Name] {
        return [.startCapture, .esc]
    }
    
    static let startCapture = Self("start capture", default: .init(.f1, modifiers: []))
    static let esc = Self("esc", default: .init(.escape, modifiers: []))
}
