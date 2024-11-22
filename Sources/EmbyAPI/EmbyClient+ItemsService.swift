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
        albums: [String]? = nil
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
                Albums: albums?.joined(separator: "|")
            )
        )
        let response = try await underlyingClient.getItems(input)
        let items = try response.ok.body.json.Items
        return (items ?? [])
            .map { item in
                Item(
                    id: item.Id!,
                    name: item.Name ?? "",
                    type: item._Type,
                    overview: item.Overview,
                    artists: (item.ArtistItems ?? []).map {
                        .init(id: $0.Id!, name: $0.Name!)
                    },
                    imageTags: item.ImageTags?.additionalProperties,
                    indexNumber: item.IndexNumber.map(Int.init),
                    parentIndexNumber: item.ParentIndexNumber.map(Int.init),
                    runTimeTicks: item.RunTimeTicks.map(Int.init),
                    premiereDate: item.PremiereDate,
                    album: item.Album,
                    albumID: item.AlbumId,
                    albumArtists: (item.AlbumArtists ?? []).map {
                        .init(id: $0.Id!, name: $0.Name!)
                    },
                    userData: item.UserData.map { userData in
                            .init(
                                isFavorite: userData.IsFavorite ?? false,
                                lastPlayedDate: userData.LastPlayedDate,
                                playCount: userData.PlayCount.map(Int.init) ?? 0
                            )
                    }
                )
            }
    }
}
