//
//  EmbyClient+ItemsService.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

extension EmbyClient {
    public func getItems(
        types: ItemType? = nil,
        genres: Genre? = nil,
        filters: ItemFilter? = nil,
        sortBy: SortOrderType? = nil,
        sortOrder: SortOrder? = nil,
        startIndex: Int32? = nil,
        limit: Int32? = nil,
        isRecursive: Bool = true,
        parentID: String? = nil,
        enableUserData: Bool = false,
        artistIds: [String]? = nil,
        albums: [String]? = nil,
        ids: [String]? = nil
    ) async throws -> [Item] {
        let input = Operations.getItems.Input(
            query: .init(
                StartIndex: startIndex,
                Limit: limit,
                Recursive: isRecursive,
                SortOrder: sortOrder?.rawValue,
                ParentId: parentID,
                IncludeItemTypes: types?.rawValue,
                Filters: filters?.rawValue,
                SortBy: sortBy?.rawValue,
                Genres: genres?.rawValue,
                EnableUserData: enableUserData,
                ArtistIds: artistIds?.joined(separator: "|"),
                Albums: albums?.joined(separator: "|"),
                Ids: ids?.joined(separator: "|"),
                UserId: userID
            )
        )
        let response = try await underlyingClient.getItems(input)
        let items = try response.ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }

    public func getItemsByUser(
        types: ItemType? = nil,
        genres: Genre? = nil,
        filters: ItemFilter? = nil,
        sortBy: SortOrderType? = nil,
        sortOrder: SortOrder? = nil,
        startIndex: Int32? = nil,
        limit: Int32? = nil,
        isRecursive: Bool = true,
        parentID: String? = nil,
        enableUserData: Bool = false,
        fields: Field? = nil,
        artistIds: [String]? = nil,
        albums: [String]? = nil,
        ids: [String]? = nil
    ) async throws -> [Item] {
        guard let userID else { throw ClientError.invalidUser }
        let input = Operations.getUsersByUseridItems.Input(
            path: .init(UserId: userID),
            query: .init(
                StartIndex: startIndex,
                Limit: limit,
                Recursive: isRecursive,
                SortOrder: sortOrder?.rawValue,
                ParentId: parentID,
                Fields: fields?.rawValue,
                IncludeItemTypes: types?.rawValue,
                Filters: filters?.rawValue,
                SortBy: sortBy?.rawValue,
                Genres: genres?.rawValue,
                EnableUserData: enableUserData,
                ArtistIds: artistIds?.joined(separator: "|"),
                Albums: albums?.joined(separator: "|"),
                Ids: ids?.joined(separator: "|")
            )
        )
        let response = try await underlyingClient.getUsersByUseridItems(input)
        let items = try response.ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }
}
