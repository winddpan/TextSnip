//
//  NSCursor.swift
//  Snapshot
//
//  Created by winddpan on 2022/10/2.
//

import Cocoa
import Foundation

extension NSCursor {
    static func pNamed(_ name: String) -> NSCursor? {
        guard let image = NSImage(named: name) else {
            return nil
        }
        var hotSpot = NSPoint(x: 0.0, y: 0.0)
        if let url = Bundle.main.url(forResource: name, withExtension: "plist") {
            let info = NSDictionary(contentsOf: url)
            hotSpot = NSPoint(x: (info?["hotx"] as? CGFloat) ?? 0.0, y: (info?["hoty"] as? CGFloat) ?? 0.0)
        }
        return NSCursor(image: image.retinaReadyCursorImage(), hotSpot: hotSpot)
    }
}

private extension NSImage {
    func retinaReadyCursorImage() -> NSImage {
        let resultImage = NSImage(size: size)
        for scale in 1 ..< 4 {
            let transform = NSAffineTransform()
            transform.scale(by: CGFloat(scale))
            if let rasterCGImage = cgImage(forProposedRect: nil, context: nil, hints: [NSImageRep.HintKey.ctm: transform]) {
                let rep = NSBitmapImageRep(cgImage: rasterCGImage)
                rep.size = size
                resultImage.addRepresentation(rep)
            }
        }
        return resultImage
    }
}
