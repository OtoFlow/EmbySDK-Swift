//
//  EmbyClient+UserLibraryService.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

extension EmbyClient {
    public func getItem(id itemId: String) async throws -> Item? {
        guard let userID else { throw ClientError.invalidUser }
        let item = try? await underlyingClient.getUsersByUseridItemsById(
            path: .init(UserId: userID, Id: itemId)
        ).ok.body.json
        return item.map { .convertFromOpenAPI($0) }
    }

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
