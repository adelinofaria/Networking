//
//  URLRequest+Mutating.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

enum NetworkingURLRequestError: Error {
    case unknown
    case failedToCreateURLComponents
    case failedToCreateNewURL
    case invalidURL(Error)
}

extension URLRequest {

    mutating func setQueryString(with queryString: [String: String], mergePolicy: Config.MergePolicy) throws(NetworkingURLRequestError) {

        try self.url?.setQueryString(with: queryString, mergePolicy: mergePolicy)
    }

    mutating func setHeaders(headers: [String: String]) {

        headers.forEach {
            self.setValue($0.value, forHTTPHeaderField: $0.key)
        }
    }

    mutating func setBody(data: Data, contentType: String? = nil) {

        self.httpBody = data

        if let contentType {

            self.setValue(contentType, forHTTPHeaderField: HTTPConstants.contentTypeHeaderKey)
        }
    }
}
