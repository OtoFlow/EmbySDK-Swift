//
//  Genre.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public enum Genre: RawValueRepresentable, ExpressibleByArrayLiteral {
    case custom(String)
    case multiple([Genre])

    public var rawValue: String {
        switch self {
        case .custom(let name):
            name
        case .multiple(let genres):
            genres.map(\.rawValue).joined(separator: "|")
        }
    }

    public init(arrayLiteral genres: Genre...) {
        self = .multiple(genres)
    }
}

extension Genre: ExpressibleByStringLiteral {
    public init(stringLiteral name: String) {
        self = .custom(name)
    }
}
