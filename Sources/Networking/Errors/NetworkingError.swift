//
//  NetworkingError.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {
    case unknown
    case generic(error: Error)
    case canceled(error: CancellationError)
    case invalidURLRequest(error: Error)
    case urlSessionError(error: Error)
    case invalidResponse(data: Data, response: URLResponse)

    // Wrapped errors
    case urlRequest(error: NetworkingURLRequestError)
    case authentication(error: NetworkAuthenticationError)
    case decodable(error: NetworkDecodableError)
    case encodable(error: NetworkEncodableError)
}
