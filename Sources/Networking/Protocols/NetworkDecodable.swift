//
//  NetworkDecodable.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `Networking` decoding  decoupling protocol.
public protocol NetworkDecodable: Sendable {

    /// Receiver must atempt to deserialize the `Data` and return a valid instance of the conforming concrete type.
    /// Any errors should be thrown using available error types of `NetworkDecodableError`.
    /// - Parameters:
    ///   - data: `Data` to be deserialized.
    /// - Returns: Instance of the conforming concrete type.
    /// - Throws: `NetworkDecodableError`
    static func decode(data: Data) async throws(NetworkDecodableError) -> Self
}
