//
//  RawValueRepresentable.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/20.
//

import Foundation

public protocol RawValueRepresentable {
    associatedtype RawValue

    var rawValue: RawValue { get }
}
