//
//  Field.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/22.
//

import Foundation

public enum Field: RawValueRepresentable, ExpressibleByArrayLiteral {
    case userPlayCount
    case userLastPlayedDate
    case multiple([Field])

    public var rawValue: String {
        switch self {
        case .userPlayCount: "UserDataPlayCount"
        case .userLastPlayedDate: "UserDataLastPlayedDate"
        case .multiple(let fields):
            fields.map(\.rawValue).joined(separator: ",")
        }
    }

    public init(arrayLiteral fields: Field...) {
        self = .multiple(fields)
    }
}
