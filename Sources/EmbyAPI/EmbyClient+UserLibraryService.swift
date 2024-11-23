//
//  EmbyClient+UserLibraryService.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

extension EmbyClient {
    public func markFavorite(_ isFavorite: Bool, itemID: String) async throws {
        guard let userID else { throw ClientError.invalidUser }
        if isFavorite {
            try await underlyingClient.postUsersByUseridFavoriteitemsById(
                path: .init(UserId: userID, Id: itemID)
            )
        } else {
            try await underlyingClient.deleteUsersByUseridFavoriteitemsById(
                path: .init(UserId: userID, Id: itemID)
            )
        }
    }
}
