//
//  User.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/19.
//

import Foundation

public struct User {
    public let id: String
    public let name: String
    public let serverID: String
    public let serverName: String
    public let dateCreated: Date?
    public let primaryImageTag: String?
}
