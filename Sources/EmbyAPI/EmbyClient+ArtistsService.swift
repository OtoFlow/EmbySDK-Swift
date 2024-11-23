//
//  EmbyClient+ArtistsService.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

extension EmbyClient {
    public func getArtists() async throws -> [Item] {
        let input = Operations.getArtists.Input(
            query: .init(),
            headers: .init(accept: [.init(contentType: .json)])
        )
        let response = try await underlyingClient.getArtists(input)
        let items = try response.ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }

    public func getArtist(name: String) async throws -> Item? {
        let input = Operations.getArtistsByName.Input(
            path: .init(Name: name),
            query: .init(UserId: userID),
            headers: .init(accept: [.init(contentType: .json)])
        )
        let response = try await underlyingClient.getArtistsByName(input)
        let item = try? response.ok.body.json
        return item.map { .convertFromOpenAPI($0) }
    }
}
