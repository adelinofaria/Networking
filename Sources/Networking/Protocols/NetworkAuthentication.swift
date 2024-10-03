//
//  NetworkAuthentication.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `Networking` authentication decoupling protocol.
public protocol NetworkAuthentication: Sendable {

    /// Receiver must modify provided `URLRequest` to successfuly satisfy the authentication requirements.
    /// - Parameters:
    ///   - urlRequest: `URLRequest` imediately  before being sent over network.
    /// - Returns: Modified `URLRequest` to the authentication specifications.
    /// - Throws: `NetworkAuthenticationError`
    func authenticate(urlRequest: URLRequest) async throws(NetworkAuthenticationError) -> URLRequest
}
