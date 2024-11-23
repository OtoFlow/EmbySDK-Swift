//
//  EmbyClient+LibraryService.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

extension EmbyClient {
    public func getMediaFolders() async throws -> [MediaFolder] {
        let items = try await underlyingClient.getLibraryMediafolders().ok.body.json.Items
        return (items ?? []).map { .convertFromOpenAPI($0) }
    }
}
