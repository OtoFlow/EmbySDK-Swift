//
//  Item.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public struct Item {
    public let id: String
    public let name: String
    public let type: String?
    public let overview: String?
    public let artists: [NameIdPair]
    public let imageTags: [String: String]?
    public let indexNumber: Int?
    public let parentIndexNumber: Int?
    public let runTimeTicks: Int?
    public let premiereDate: Date?
    public let album: String?
    public let albumID: String?
    public let albumArtists: [NameIdPair]
    public let userData: UserData?
}
