//
//  MediaFolder.swift
//  EmbyAPI
//
//  Created by Xianhe Meng on 2024/11/23.
//

import Foundation

public struct MediaFolder {
    let id: String
    let collectionType: CollectionType?
}

extension MediaFolder {
    static func convertFromOpenAPI(_ item: Components.Schemas.BaseItemDto) -> MediaFolder {
        MediaFolder(
            id: item.Id!,
            collectionType: .init(rawValue: item.CollectionType ?? "")
        )
    }
}
