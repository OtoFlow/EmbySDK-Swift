//
//  Item.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public struct Item {
    public let id: String
    public let name: String
    public let type: String?
    public let overview: String?
    public let artists: [NameIdPair]?
    public let imageTags: [String: String]?
    public let indexNumber: Int?
    public let parentIndexNumber: Int?
    public let runTimeTicks: Int?
    public let premiereDate: Date?
    public let album: String?
    public let albumID: String?
    public let albumArtists: [NameIdPair]?
    public let userData: UserData?
    public let mediaStreams: [MediaStream]?
}

extension Item {
    static func convertFromOpenAPI(_ item: Components.Schemas.BaseItemDto) -> Item {
        Item(
            id: item.Id!,
            name: item.Name ?? "",
            type: item._Type,
            overview: item.Overview,
            artists: item.ArtistItems?.map(\.NameIdPair),
            imageTags: item.ImageTags?.additionalProperties,
            indexNumber: item.IndexNumber.map(Int.init),
            parentIndexNumber: item.ParentIndexNumber.map(Int.init),
            runTimeTicks: item.RunTimeTicks.map(Int.init),
            premiereDate: item.PremiereDate,
            album: item.Album,
            albumID: item.AlbumId,
            albumArtists: item.AlbumArtists?.map(\.NameIdPair),
            userData: item.UserData.map(UserData.convertFromOpenAPI),
            mediaStreams: item.MediaStreams.map { $0.map(MediaStream.convertFromOpenAPI) }
        )
    }
}
