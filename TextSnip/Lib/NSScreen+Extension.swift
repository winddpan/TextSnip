//
//  NSScreen+Extension.swift
//  Snapshot
//
//  Created by winddpan on 2022/9/18.
//

import Cocoa
import Foundation

extension NSScreen {
    static func currentScreenForMouseLocation() -> NSScreen? {
        let mouseLocation = NSEvent.mouseLocation
        return NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) })
    }
}

extension CGRect {
    var screenRect: CGRect {
        let mainScreen = NSScreen.screens.first(where: { $0.frame.origin == .zero })
        if let mainScreen = mainScreen {
            return CGRect(x: self.origin.x, y: mainScreen.frame.size.height - self.size.height - self.origin.y, width: self.size.width, height: self.size.height)
        }
        return self
    }
}

extension CGRect {
    func fixNegativeSize() -> CGRect {
        var rect = self
        if rect.size.width < 0 {
            rect.origin.x += rect.size.width
            rect.size.width = -rect.size.width
        }
        if rect.size.height < 0 {
            rect.origin.y += rect.size.height
            rect.size.height = -rect.size.height
        }
        return rect
    }
}

extension CGRect {
    init(center: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(x: center.x - width / 2, y: center.y - height / 2, width: width, height: height)
    }
}
