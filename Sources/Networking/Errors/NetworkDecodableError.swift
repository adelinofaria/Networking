//
//  NetworkDecodableError.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Expected thrown errors coming the usage of the `NetworkDecodable` protocol.
public enum NetworkDecodableError: Error {

    /// Unexpected and unsupported error.
    case unknown

    /// General purpose error case, used when there's no especialized alternative.
    case generic(error: Error)

    /// `HTTPURLResponse`'s `statusCode` is outside of the configured success range.
    case unexpectedStatusCode(data: Data, response: HTTPURLResponse)

    /// Could not decode object from the provided `Data`.
    case invalidData(data: Data, error: Error?)
}
