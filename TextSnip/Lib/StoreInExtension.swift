//
//  StoreInExtension.swift
//  Ece
//
//  Created by PAN on 2022/7/12.
//

import Combine
import Foundation

public extension AnyCancellable {
    final func store(in object: AnyObject) {
        let wrapper = _getAnyCancellableWrapper(object)
        store(in: &wrapper.cancellableSet)
    }
}

private class AnyCancellableWrapper {
    var cancellableSet = Set<AnyCancellable>()
}

private var cancellableContext: UInt8 = 0

private func synchronizedBag<T>(_ obj: AnyObject, _ action: () -> T) -> T {
    objc_sync_enter(obj)
    let result = action()
    objc_sync_exit(obj)
    return result
}

private func _getAnyCancellableWrapper(_ obj: AnyObject) -> AnyCancellableWrapper {
    return synchronizedBag(obj) {
        if let object = objc_getAssociatedObject(obj, &cancellableContext) as? AnyCancellableWrapper {
            return object
        }
        let object = AnyCancellableWrapper()
        objc_setAssociatedObject(obj, &cancellableContext, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return object
    }
}
