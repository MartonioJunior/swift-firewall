//
//  FirewallState.swift
//
//
//  Created by Martônio Júnior on 13/10/23.
//

import Foundation

public enum FirewallState<Value> {
    // MARK: Cases
    case free(Value)
    case locked(Value, Double)

    // MARK: Properties
    var value: Value {
        switch self {
            case .free(let state): state
            case .locked(let state, _): state
        }
    }
}

// MARK: Self: Equatable
extension FirewallState: Equatable where Value: Equatable {}
