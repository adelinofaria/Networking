//
//  NetworkEncodable.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `Networking` encoding  decoupling protocol.
public protocol NetworkEncodable: Sendable, Hashable {
    
    /// Optional value to be included into `URLRequest` as HTTP header `Content-Type`.
    var contentType: String? { get }

    /// Receiver must atempt to serialize itself into `Data`.
    /// Any errors should be thrown using available error types of `NetworkEncodableError`.
    /// - Returns: Serialized object as Data.
    /// - Throws: `NetworkEncodableError`
    func encode() async throws(NetworkEncodableError) -> Data
}
