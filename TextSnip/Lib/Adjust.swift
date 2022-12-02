//
//  Adjust.swift
//  Snapshot
//
//  Created by winddpan on 2022/10/2.
//

import Cocoa
import Foundation

enum AdjustAction: Int, CaseIterable {
    case topLeading
    case top
    case topTrailing
    case leading
    case trailing
    case bottomLeading
    case bottom
    case bottomTrailing
    case move
}

extension AdjustAction {
    var cursor: NSCursor {
        switch self {
        case .move:
            return .pNamed("move") ?? .closedHand
        case .topLeading, .bottomTrailing:
            return .pNamed("resizenorthwestsoutheast") ?? .arrow
        case .top, .bottom:
            return .resizeUpDown
        case .topTrailing, .bottomLeading:
            return .pNamed("resizenortheastsouthwest") ?? .arrow
        case .leading, .trailing:
            return .resizeLeftRight
        }
    }
}

struct Adjust: Equatable {
    let action: AdjustAction
    let startRect: CGRect

    func translation(_ translation: CGSize) -> CGRect {
        var rect = startRect
        switch action {
        case .move:
            rect.origin.x += translation.width
            rect.origin.y += translation.height
        case .topLeading:
            rect.origin.x += translation.width
            rect.origin.y += translation.height
            rect.size.width -= translation.width
            rect.size.height -= translation.height
        case .top:
            rect.origin.y += translation.height
            rect.size.height -= translation.height
        case .topTrailing:
            rect.origin.y += translation.height
            rect.size.width += translation.width
            rect.size.height -= translation.height
        case .leading:
            rect.origin.x += translation.width
            rect.size.width -= translation.width
        case .trailing:
            rect.size.width += translation.width
        case .bottomLeading:
            rect.origin.x += translation.width
            rect.size.width -= translation.width
            rect.size.height += translation.height
        case .bottom:
            rect.size.height += translation.height
        case .bottomTrailing:
            rect.size.width += translation.width
            rect.size.height += translation.height
        }
        return rect.fixNegativeSize()
    }
}

extension CGRect {
    private func hotArea(for action: AdjustAction, throttle: CGFloat) -> CGRect {
        let center = anchorPoint(for: action)
        switch action {
        case .move:
            return .init(center: center, width: width - throttle, height: height - throttle)
        case .topLeading:
            return .init(center: center, width: throttle, height: throttle)
        case .top:
            return .init(center: center, width: width, height: throttle)
        case .topTrailing:
            return .init(center: center, width: throttle, height: throttle)
        case .leading:
            return .init(center: center, width: throttle, height: height)
        case .trailing:
            return .init(center: center, width: throttle, height: height)
        case .bottomLeading:
            return .init(center: center, width: throttle, height: throttle)
        case .bottom:
            return .init(center: center, width: width, height: throttle)
        case .bottomTrailing:
            return .init(center: center, width: throttle, height: throttle)
        }
    }

    func anchorPoint(for action: AdjustAction) -> CGPoint {
        switch action {
        case .move:
            return origin + CGPoint(x: width / 2, y: height / 2)
        case .topLeading:
            return origin
        case .top:
            return origin + CGPoint(x: width / 2, y: 0)
        case .topTrailing:
            return origin + CGPoint(x: width, y: 0)
        case .leading:
            return origin + CGPoint(x: 0, y: height / 2)
        case .trailing:
            return origin + CGPoint(x: width, y: height / 2)
        case .bottomLeading:
            return origin + CGPoint(x: 0, y: height)
        case .bottom:
            return origin + CGPoint(x: width / 2, y: height)
        case .bottomTrailing:
            return origin + CGPoint(x: width, y: height)
        }
    }

    func adjustAction(near location: CGPoint, throttle: CGFloat, allows: [AdjustAction]) -> AdjustAction? {
        let allows = Set(allows)
        var actionOrders: [AdjustAction] = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing, .top, .leading, .bottom, .trailing, .move]
        actionOrders = actionOrders.filter { allows.contains($0) }
        for action in actionOrders {
            if hotArea(for: action, throttle: throttle).contains(location) {
                return action
            }
        }
        return nil
    }
}
