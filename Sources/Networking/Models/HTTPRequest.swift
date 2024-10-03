//
//  HTTPRequest.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `HTTPRequest` contains all the necessary information to build a `URLRequest` for networking.
/// All inits should be private and usage should be restricted to the static methods prefixed by a HTTP method.
public struct HTTPRequest<T: NetworkDecodable, E: NetworkDecodable> {

    /// Base `URL` on which we might add additional query string from `query`.
    public let url: URL

    /// HTTP method to be used.
    public let method: HTTPMethod

    /// Additional query string items specific to this request, to be appended to `url`.
    public let query: [HTTPQueryItem]?

    /// Additional headers specific to this request.
    public let headers: [String: String]?

    /// Based on HTTP method, you can optionally add a payload with a provided object conforming to `NetworkEncodable`.
    public let body: (any NetworkEncodable)?
    
    /// Request specific timeout value.
    public var timeout: TimeInterval?

    /// GET HTTP method static initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - timeout: Request specific timeout.
    /// - Returns: Fully configured `HTTPRequest`, ready to be used by `Networking.request(request:)`.
    public static func get(url: URL,
                           query: [HTTPQueryItem]? = nil,
                           headers: [String: String]? = nil,
                           timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .get, query: query, headers: headers, timeout: timeout)
    }

    /// HEAD HTTP method static initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - timeout: Request specific timeout.
    /// - Returns: Fully configured `HTTPRequest`, ready to be used by `Networking.request(request:)`.
    public static func head(url: URL,
                            query: [HTTPQueryItem]? = nil,
                            headers: [String: String]? = nil,
                            timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .head, query: query, headers: headers, timeout: timeout)
    }

    /// POST HTTP method static initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - body: `URLRequest`'s `httpBody` payload.
    ///   - timeout: Request specific timeout.
    /// - Returns: Fully configured `HTTPRequest`, ready to be used by `Networking.request(request:)`.
    public static func post(url: URL,
                            query: [HTTPQueryItem]? = nil,
                            headers: [String: String]? = nil,
                            body: (any NetworkEncodable)? = nil,
                            timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .post, query: query, headers: headers, body: body, timeout: timeout)
    }

    /// PUT HTTP method static initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - body: `URLRequest`'s `httpBody` payload.
    ///   - timeout: Request specific timeout.
    /// - Returns: Fully configured `HTTPRequest`, ready to be used by `Networking.request(request:)`.
    public static func put(url: URL,
                           query: [HTTPQueryItem]? = nil,
                           headers: [String: String]? = nil,
                           body: (any NetworkEncodable)? = nil,
                           timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .put, query: query, headers: headers, body: body, timeout: timeout)
    }

    /// DELETE HTTP method static initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - timeout: Request specific timeout.
    /// - Returns: Fully configured `HTTPRequest`, ready to be used by `Networking.request(request:)`.
    public static func delete(url: URL,
                              query: [HTTPQueryItem]? = nil,
                              headers: [String: String]? = nil,
                              timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .delete, query: query, headers: headers, timeout: timeout)
    }

    /// PATCH HTTP method static initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - body: `URLRequest`'s `httpBody` payload.
    ///   - timeout: Request specific timeout.
    /// - Returns: Fully configured `HTTPRequest`, ready to be used by `Networking.request(request:)`.
    public static func patch(url: URL,
                             query: [HTTPQueryItem]? = nil,
                             headers: [String: String]? = nil,
                             body: (any NetworkEncodable)? = nil,
                             timeout: TimeInterval? = nil) -> Self {

        .init(url: url, method: .patch, query: query, headers: headers, body: body, timeout: timeout)
    }
    
    /// Private default initializer.
    /// - Parameters:
    ///   - url: Base `URL`.
    ///   - method: HTTP method.
    ///   - query: Additional query items.
    ///   - headers: Request specific HTTP headers.
    ///   - body: `URLRequest`'s `httpBody` payload.
    ///   - timeout: Request specific timeout.
    private init(url: URL,
                 method: HTTPMethod,
                 query: [HTTPQueryItem]? = nil,
                 headers: [String: String]? = nil,
                 body: (any NetworkEncodable)? = nil,
                 timeout: TimeInterval? = nil) {
        self.url = url
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
        self.timeout = timeout
    }

    /// Converts `HTTPRequest` into a `URLRequest` to be used for a `URLSession` dataTask.
    /// - Parameters:
    ///   - config: `Networking`'s `Config` to inject default values, shared values and merge policies configurations.
    /// - Returns: Fully configured `URLRequest`, ready to be used by `URLSession.data(for:)`.
    func urlRequest(with config: Config) async throws(NetworkingError) -> URLRequest {

        var urlRequest = URLRequest(url: self.url)

        urlRequest.httpMethod = self.method.rawValue
        urlRequest.setValue(await HTTPConstants.userAgent, forHTTPHeaderField: HTTPConstants.userAgentHeaderKey)
        urlRequest.setHeaders(headers: config.sharedHeaders)
        urlRequest.timeoutInterval = self.timeout ?? config.timeout

        if let query = self.query {
            do {
                try urlRequest.setQuery(with: query, mergePolicy: config.queryItemMergePolicy)
            } catch {
                throw .urlRequest(error: error)
            }
        }

        if let headers = self.headers {
            urlRequest.setHeaders(headers: headers)
        }

        if let body = self.body {
            do {
                try await urlRequest.setBody(object: body)
            } catch {
                throw .encodable(error: error)
            }
        }

        return urlRequest
    }
}

