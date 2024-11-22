//
//  ItemFilter.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/22.
//

public enum ItemFilter: RawValueRepresentable, ExpressibleByArrayLiteral {
    case isFolder
    case isNotFolder
    case isUnplayed
    case isPlayed
    case isFavorite
    case isResumable
    case likes
    case dislikes
    case multiple([ItemFilter])

    public var rawValue: String {
        switch self {
        case .isFolder: "IsFolder"
        case .isNotFolder: "IsNotFolder"
        case .isUnplayed: "IsUnplayed"
        case .isPlayed: "IsPlayed"
        case .isFavorite: "IsFavorite"
        case .isResumable: "IsResumable"
        case .likes: "Likes"
        case .dislikes: "Dislikes"
        case .multiple(let filters):
            filters.map(\.rawValue).joined(separator: ",")
        }
    }

    public init(arrayLiteral filters: ItemFilter...) {
        self = .multiple(filters)
    }
}
