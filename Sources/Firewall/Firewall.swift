//
//  Firewall.swift
//  
//
//  Created by Martônio Júnior on 23/09/23.
//

public import Foundation

@available(macOS 14.0, *)
public struct Firewall<Value> {
    public typealias State = FirewallState<Value>
    public typealias Reasoner = (Self) -> State

    // MARK: Variables
    var state: State
    var reasoner: Reasoner

    var value: Value { state.value }

    // MARK: Initializer
    public init(
        _ state: State,
        reasoner: @escaping Reasoner
    ) {
        self.state = state
        self.reasoner = reasoner
    }

    // MARK: Methods
    public mutating func lock(_ newState: Value, for duration: TimeInterval) -> Value {
        state = .locked(newState, duration)
        return newState
    }

    public mutating func update(_ delta: TimeInterval) {
        state = switch state {
            case let .locked(state, time) where time > delta:
                .locked(state, time - delta)
            default:
                reasoner(self)
        }
    }
}

// MARK: DotSyntax
@available(macOS 14.0, *)
public extension Firewall {
    static func free(_ initialState: Value, reasoner: @escaping Reasoner) -> Self {
        .init(.free(initialState), reasoner: reasoner)
    }

    static func locked(_ initialState: Value, for duration: TimeInterval, reasoner: @escaping Reasoner) -> Self {
        .init(.locked(initialState, duration), reasoner: reasoner)
    }
}
