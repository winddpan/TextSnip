import Foundation
import SwiftUI
import VisionKit

@MainActor
struct LiveTextView: NSViewRepresentable {
    let image: NSImage
    let imageView = LiveTextImageView()
    let overlayView = ImageAnalysisOverlayView()
    let analyzer = ImageAnalyzer()

    func makeNSView(context: Context) -> some NSView {
        imageView.image = image
        overlayView.preferredInteractionTypes = .automatic
        overlayView.autoresizingMask = [.width, .height]
        overlayView.frame = imageView.bounds
        overlayView.trackingImageView = imageView
        overlayView.delegate = context.coordinator
        imageView.addSubview(overlayView)

        return imageView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let image = imageView.image else { return }

        imageView.wantsLayer = true
        imageView.layer?.borderWidth = 2
        imageView.layer?.borderColor = NSColor(red: 230 / 255, green: 126 / 255, blue: 34 / 255, alpha: 1).cgColor

        Task { @MainActor in
            do {
                let configuration = ImageAnalyzer.Configuration([.text])
                let analysis = try await analyzer.analyze(image, orientation: .up, configuration: configuration)
                overlayView.analysis = analysis
                overlayView.selectableItemsHighlighted = true

                if analysis.hasResults(for: .text) {
                    imageView.layer?.borderColor = NSColor(red: 46.0 / 255, green: 204.0 / 255, blue: 113.0 / 255, alpha: 1).cgColor
                } else {
                    imageView.layer?.borderColor = NSColor(red: 231 / 255, green: 22 / 255, blue: 0 / 255, alpha: 1).cgColor
                }

            } catch {
                print(error.localizedDescription)
                imageView.layer?.borderColor = NSColor(red: 231 / 255, green: 22 / 255, blue: 0 / 255, alpha: 1).cgColor
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: ImageAnalysisOverlayViewDelegate {
        
    }
}

class LiveTextImageView: NSImageView {
    override var intrinsicContentSize: NSSize {
        .zero
    }
}
