//
//  SnipView.swift
//  TextSnip
//
//  Created by PAN on 2022/12/1.
//

import SwiftUI

struct SnipView: View {
    @ObservedObject var viewModel: SnipViewModel
    @State private var rect: CGRect?

    var onExit: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(nsImage: viewModel.screenImage)

            if let snipImage = viewModel.snipImage, let endRect = viewModel.endRect {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onExit()
                    }

                LiveTextView(image: snipImage)
                    .frame(width: endRect.width, height: endRect.height)
                    .offset(.init(width: endRect.origin.x, height: endRect.origin.y))
            } else {
                Color.clear
                    .border(.blue, width: 2)
                
                Canvas(rendersAsynchronously: false) { context, _ in
                    if let rect = rect, rect.size != .zero {
                        context.withCGContext { cgContext in
                            cgContext.setStrokeColor(CGColor(red: 236.0 / 255, green: 240.0 / 255, blue: 241.0 / 255, alpha: 1))
                            cgContext.setLineWidth(1)
                            cgContext.setFillColor(.white.copy(alpha: 0.1)!)

                            let path = CGPath(rect: rect, transform: nil)
                            cgContext.addPath(path)
                            cgContext.strokePath()
                            cgContext.fill([rect])
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gesture(drag)
            }
        }
    }

    var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if rect == nil {
                    rect = .init(origin: value.startLocation, size: .zero)
                } else {
                    rect = .init(origin: value.startLocation, size: value.translation).fixNegativeSize()
                }
            }
            .onEnded { _ in
                if let r = rect, r.size != .zero {
                    rect = nil
                    viewModel.endSnip(rect: r)
                }
            }
    }
}
