//
//  NetworkingError.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Expected thrown errors coming the usage of the `Networking` public methods.
public enum NetworkingError: Error {

    /// Unexpected and unsupported error.
    case unknown

    /// General purpose error case, used when there's no especialized alternative.
    case generic(error: Error)

    /// `Task` was canceled, transaction aborted.
    case canceled(error: CancellationError)

    /// Error captured from Foundation's `URLSession.data(for:)`.
    case urlSessionError(error: Error)

    /// Expected an `HTTPURLResponse` from `URLSession.data(for:)`, but got a `URLResponse` instead.
    case invalidResponse(data: Data, response: URLResponse)

    /// Wrapper error from `NetworkingURLRequestError`.
    case urlRequest(error: NetworkingURLRequestError)

    /// Wrapper error from `NetworkAuthenticationError`.
    case authentication(error: NetworkAuthenticationError)

    /// Wrapper error from `NetworkDecodableError`.
    case decodable(error: NetworkDecodableError)

    /// Wrapper error from `NetworkEncodableError`.
    case encodable(error: NetworkEncodableError)
}
