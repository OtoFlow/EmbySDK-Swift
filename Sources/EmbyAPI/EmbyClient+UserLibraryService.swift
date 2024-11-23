//
//  EmbyClient+UserLibraryService.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

extension EmbyClient {
    @discardableResult
    public func markFavorite(_ isFavorite: Bool, itemID: String) async throws -> UserData {
        guard let userID else { throw ClientError.invalidUser }
        let userData: Components.Schemas.UserItemDataDto
        if isFavorite {
            userData = try await underlyingClient.postUsersByUseridFavoriteitemsById(
                path: .init(UserId: userID, Id: itemID)
            ).ok.body.json
        } else {
            userData = try await underlyingClient.deleteUsersByUseridFavoriteitemsById(
                path: .init(UserId: userID, Id: itemID)
            ).ok.body.json
        }
        return .convertFromOpenAPI(userData)
    }
}
