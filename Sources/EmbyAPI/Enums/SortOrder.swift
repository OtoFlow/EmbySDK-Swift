//
//  SortOrder.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public enum SortOrder: String {
    case ascending = "Ascending"
    case descending = "Descending"
}

public enum SortOrderType: RawValueRepresentable, ExpressibleByArrayLiteral {
    case album
    case albumArtist
    case artist
    case budget
    case communityRating
    case criticRating
    case dateCreated
    case datePlayed
    case playCount
    case premiereDate
    case productionYear
    case sortName
    case random
    case revenue
    case runtim
    case multiple([SortOrderType])

    public var rawValue: String {
        switch self {
        case .album: "Album"
        case .albumArtist: "AlbumArtist"
        case .artist: "Artist"
        case .budget: "Budget"
        case .communityRating: "CommunityRating"
        case .criticRating: "CriticRating"
        case .dateCreated: "DateCreated"
        case .datePlayed: "DatePlayed"
        case .playCount: "PlayCount"
        case .premiereDate: "PremiereDate"
        case .productionYear: "ProductionYear"
        case .sortName: "SortName"
        case .random: "Random"
        case .revenue: "Revenue"
        case .runtim: "Runtim"
        case .multiple(let array):
            array.map(\.rawValue).joined(separator: ",")
        }
    }

    public init(arrayLiteral elements: SortOrderType...) {
        self = .multiple(elements)
    }
}
