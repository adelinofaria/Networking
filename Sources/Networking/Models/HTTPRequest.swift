//
//  HTTPRequest.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public struct HTTPRequest {

    public let url: URL
    public let method: HTTPMethod
    public let query: [HTTPQueryItem]?
    public let headers: [HTTPHeader]?
    public let body: (any NetworkEncodable)?

    public var timeout: TimeInterval?

    public static func get(url: URL,
                           query: [HTTPQueryItem]? = nil,
                           headers: [HTTPHeader]? = nil,
                           timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .get, query: query, headers: headers, timeout: timeout)
    }

    public static func head(url: URL,
                            query: [HTTPQueryItem]? = nil,
                            headers: [HTTPHeader]? = nil,
                            timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .head, query: query, headers: headers, timeout: timeout)
    }

    public static func post(url: URL,
                            query: [HTTPQueryItem]? = nil,
                            headers: [HTTPHeader]? = nil,
                            body: (any NetworkEncodable)? = nil,
                            timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .post, query: query, headers: headers, body: body, timeout: timeout)
    }

    public static func put(url: URL,
                           query: [HTTPQueryItem]? = nil,
                           headers: [HTTPHeader]? = nil,
                           body: (any NetworkEncodable)? = nil,
                           timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .put, query: query, headers: headers, body: body, timeout: timeout)
    }

    public static func delete(url: URL,
                              query: [HTTPQueryItem]? = nil,
                              headers: [HTTPHeader]? = nil,
                              timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .delete, query: query, headers: headers, timeout: timeout)
    }

    public static func patch(url: URL,
                             query: [HTTPQueryItem]? = nil,
                             headers: [HTTPHeader]? = nil,
                             body: (any NetworkEncodable)? = nil,
                             timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .patch, query: query, headers: headers, body: body, timeout: timeout)
    }

    private init(url: URL,
                 method: HTTPMethod,
                 query: [HTTPQueryItem]? = nil,
                 headers: [HTTPHeader]? = nil,
                 body: (any NetworkEncodable)? = nil,
                 timeout: TimeInterval? = nil) {
        self.url = url
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
        self.timeout = timeout
    }

    func urlRequest(with config: Config) async throws -> URLRequest {

        var urlRequest = URLRequest(url: self.url)

        urlRequest.httpMethod = self.method.rawValue
        urlRequest.setValue(await HTTPConstants.userAgent, forHTTPHeaderField: HTTPConstants.userAgentHeaderKey)
        urlRequest.timeoutInterval = self.timeout ?? config.timeout

        // FIXME: maybe have shared headers in config and add them here

        if let query = self.query {
            try urlRequest.setQuery(with: query, mergePolicy: config.queryItemMergePolicy)
        }

        if let headers = self.headers {
            urlRequest.setHeaders(headers: headers)
        }

        if let body = self.body {
            try await urlRequest.setBody(object: body)
        }

        return urlRequest
    }
}

