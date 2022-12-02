//
//  PassthroughSubjectErased.swift
//  MixedLibrary
//
//  Created by PAN on 2022/9/21.
//

#if canImport(Combine)

import Combine
import Foundation

@propertyWrapper
@available(iOS 13.0, tvOS 13.0, OSX 10.15, *)
public class PassthroughSubjectErased<Output, Failure: Error>: Subject {
    let subject = PassthroughSubject<Output, Failure>.init()

    public var wrappedValue: AnyPublisher<Output, Failure> {
        return subject.share().eraseToAnyPublisher()
    }

    public init() {}

    public func send(_ value: Output) {
        subject.send(value)
    }

    public func send(completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }

    public func send(subscription: Subscription) {
        subject.send(subscription: subscription)
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

#endif
