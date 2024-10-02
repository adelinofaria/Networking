//
//  URLRequestMutatingTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct URLRequestMutatingTests {

    // MARK: Setup

    static let setQueryArguments1: [URL?] = [
        URL(string: "https://domain.top/path"),
        URL(string: "https://domain.top/path?"),
        URL(string: "https://domain.top/path?z=99"),
        URL(string: "https://domain.top/path?a=1"),
        URL(string: "https://domain.top/path?a=1&a=1")
    ]

    static let setQueryArguments2: [[HTTPQueryItem]] = [
        [],
        [.init(name: "a", value: "1")],
        [.init(name: "b", value: "2")],
        [.init(name: "a", value: "1"), .init(name: "b", value: "2")],
        [.init(name: "a", value: "1"), .init(name: "a", value: "1")]
    ]

    // MARK: Tests

    @Test("setQuery(with:mergePolicy:)", arguments: setQueryArguments1, setQueryArguments2)
    func setQuery(url: URL?, queryItems: [HTTPQueryItem]) async throws {

        var urlRequest = URLRequest(url: try #require(url))

        #expect(urlRequest.url?.queryItems.count == url?.queryItems.count)

        try urlRequest.setQuery(with: queryItems, mergePolicy: .append)

        #expect(urlRequest.url?.queryItems.count == (url?.queryItems.count ?? 0) + queryItems.count)
    }

    @Test("setHeaders(headers:)", arguments: [[:], ["a": "1"], ["a": "1", "b": "2"]])
    func setHeaders(headers: [String: String]) async throws {

        var urlRequest = URLRequest(url: .sample)

        #expect(urlRequest.allHTTPHeaderFields == nil)

        urlRequest.setHeaders(headers: headers)

        #expect(urlRequest.allHTTPHeaderFields?.count ?? 0 == headers.count)
    }

    @Test("setBody(object:)")
    func setBody() async throws {

        let encodable = EncodableObject(a: true, b: 1, c: "abc")
        var urlRequest = URLRequest(url: .sample)

        #expect(urlRequest.allHTTPHeaderFields?[HTTPConstants.contentTypeHeaderKey] == nil)
        #expect(urlRequest.httpBody == nil)

        try await urlRequest.setBody(object: encodable)

        let data = try await encodable.encode()

        #expect(urlRequest.allHTTPHeaderFields?[HTTPConstants.contentTypeHeaderKey] == "application/test")
        #expect(urlRequest.httpBody?.count == data.count)
    }
}
