//
//  PublicSystemInfo.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/19.
//

import Foundation

public struct PublicSystemInfo {
    public let localAdress: String?
    public let localAdresses: [String]?
    public let wanAdress: String?
    public let remoteAdresses: [String]?
    public let serverName: String
    public let version: String?
    public let id: String
}
