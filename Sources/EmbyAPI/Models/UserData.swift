//
//  UserData.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public struct UserData {
    public var isFavorite: Bool
    public var lastPlayedDate: Date?
    public var playCount: Int?
}

extension UserData {
    static func convertFromOpenAPI(_ userData: Components.Schemas.UserItemDataDto) -> UserData {
        UserData(
            isFavorite: userData.IsFavorite ?? false,
            lastPlayedDate: userData.LastPlayedDate,
            playCount: userData.PlayCount.map(Int.init)
        )
    }
}
