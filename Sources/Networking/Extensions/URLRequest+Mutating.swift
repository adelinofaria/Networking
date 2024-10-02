//
//  URLRequest+Mutating.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension URLRequest {

    /// Append new `HTTPQueryItem` to `URL` using `URLComponents.queryItems` interface and `MergePolicy` strategy.
    /// - Parameters:
    ///   - query: List of `HTTPQueryItem` to be appended.
    ///   - mergePolicy: Merge strategy to be used to solve colisions.
    mutating func setQuery(with query: [HTTPQueryItem], mergePolicy: MergePolicy) throws(NetworkingURLRequestError) {

        try self.url?.setQuery(with: query, mergePolicy: mergePolicy)
    }

    /// Append new pairs of key/value to the list of HTTP headers
    /// - Parameter headers: Dictionary of HTTP headers
    mutating func setHeaders(headers: [String: String]) {

        headers.forEach {
            self.setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }

    /// Set payload to the `URLRequest` by leveraging `NetworkEncodable` protocol. It will assign the data to
    /// `URLRequest.httpBody` and set the corresponding HTTP headers `Content-Type` (if implemented).
    /// - Parameter object: Object implenting `NetworkEncodable`.
    mutating func setBody(object: any NetworkEncodable) async throws(NetworkEncodableError) {

        self.httpBody = try await object.encode()

        if let contentType = object.contentType {

            self.setValue(contentType, forHTTPHeaderField: HTTPConstants.contentTypeHeaderKey)
        }
    }
}
