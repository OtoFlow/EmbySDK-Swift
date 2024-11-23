//
//  NameIdPair.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public struct NameIdPair {
    public let id: String
    public let name: String
}

protocol NameIdPairProtocol {
    var Name: String? { get }
    var Id: String? { get }
}

extension NameIdPairProtocol {
    func convertToNameIdPair() -> NameIdPair {
        NameIdPair(id: Id!, name: Name ?? "")
    }
}

extension Components.Schemas.NameIdPair: NameIdPairProtocol { }
