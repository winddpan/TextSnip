//
//  SnipViewModel.swift
//  TextSnip
//
//  Created by PAN on 2022/12/1.
//

import SwiftUI
import VisionKit

class SnipViewModel: ObservableObject {
    @Published private(set) var endRect: CGRect?
    @Published private(set) var snipImage: NSImage?

    let screenImage: NSImage

    init(screenImage: NSImage) {
        self.screenImage = screenImage
    }

    func endSnip(rect: CGRect) {
        let snipedImage = snipImage(rect: rect)
        endRect = rect
        snipImage = snipedImage
    }

    private func snipImage(rect: CGRect) -> NSImage {
        guard rect.size != .zero, let imageRef = screenImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else {
            return screenImage
        }
        let imageScale = CGFloat(imageRef.width) / screenImage.size.width

        var croppingRect = rect
        croppingRect.origin.x *= imageScale
        croppingRect.origin.y *= imageScale
        croppingRect.size.width *= imageScale
        croppingRect.size.height *= imageScale

        let drawImage = imageRef.cropping(to: croppingRect)
        let newImage = NSImage(cgImage: drawImage!, size: rect.size)
        return newImage
    }
}
