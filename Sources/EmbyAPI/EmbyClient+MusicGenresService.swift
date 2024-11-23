//
//  EmbyClient+MusicGenresService.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

extension EmbyClient {
    public func getMusicGenres() async throws -> [Item] {
        let items = try await underlyingClient.getMusicgenres().ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }
}
