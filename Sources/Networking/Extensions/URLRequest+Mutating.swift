//
//  URLRequest+Mutating.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension URLRequest {

    mutating func setQuery(with query: [HTTPQueryItem], mergePolicy: Config.MergePolicy) throws(NetworkingURLRequestError) {

        try self.url?.setQuery(with: query, mergePolicy: mergePolicy)
    }

    mutating func setHeaders(headers: [HTTPHeader]) {

        headers.forEach {
            self.setValue($0.value, forHTTPHeaderField: $0.name)
        }
    }

    mutating func setBody(object: any NetworkEncodable) async throws {

        self.httpBody = try await object.encode()

        if let contentType = object.contentType {

            self.setValue(contentType, forHTTPHeaderField: HTTPConstants.contentTypeHeaderKey)
        }
    }
}
