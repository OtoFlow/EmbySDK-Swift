//
//  ItemType.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public enum ItemType: RawValueRepresentable {
    case music
    case musicVideo
    case musicAlbum
    case multiple([ItemType])

    public var rawValue: String {
        switch self {
        case .music: "Music"
        case .musicVideo: "MusicVideo"
        case .musicAlbum: "MusicAlbum"
        case .multiple(let types):
            types.map(\.rawValue).joined(separator: ",")
        }
    }

    public init(arrayLiteral types: ItemType...) {
        self = .multiple(types)
    }
}
