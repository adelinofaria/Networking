//
//  URL+HTTPQueryItem.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension URL {

    /// Append new `HTTPQueryItem` to `URL` using `URLComponents.queryItems` interface and `MergePolicy` strategy.
    /// - Parameters:
    ///   - query: List of `HTTPQueryItem` to be appended.
    ///   - mergePolicy: Merge strategy to be used to solve colisions.
    mutating func setQuery(with query: [HTTPQueryItem], mergePolicy: MergePolicy) throws(NetworkingURLRequestError) {

        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw .failedToCreateURLComponents
        }

        var queryItems = urlComponents.queryItems ?? []

        queryItems.append(query, policy: mergePolicy)

        urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            self = url
        } else {
            throw .failedToCreateURLFromURLComponents
        }
    }
}
