//
//  URLHTTPQueryItemTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct URLHTTPQueryItemTests {

    // MARK: Setup

    static let arguments1: [URL?] = [
        URL(string: "https://domain.top/path"),
        URL(string: "https://domain.top/path?"),
        URL(string: "https://domain.top/path?z=99"),
        URL(string: "https://domain.top/path?a=1"),
        URL(string: "https://domain.top/path?a=1&a=1")
    ]

    static let arguments2: [[HTTPQueryItem]] = [
        [],
        [.init(name: "a", value: "1")],
        [.init(name: "b", value: "2")],
        [.init(name: "a", value: "1"), .init(name: "b", value: "2")],
        [.init(name: "a", value: "1"), .init(name: "a", value: "1")]
    ]

    // MARK: Tests

    @Test("setQuery(with:mergePolicy: .append)", arguments: arguments1, arguments2)
    func setQueryWithAppend(url: URL?, queryItems: [HTTPQueryItem]) async throws {

        var url = try #require(url)
        let expectedURLQueryItemsCount = url.queryItems.count + queryItems.count

        try url.setQuery(with: queryItems, mergePolicy: .append)

        #expect(url.queryItems.count == expectedURLQueryItemsCount)
    }

    @Test("setQuery(with:mergePolicy: .overwrite)", arguments: arguments1, arguments2)
    func setQueryWithOverwrite(url: URL?, queryItems: [HTTPQueryItem]) async throws {

        var url = try #require(url)
        let expectedURLCount = url.queryItems(with: queryItems).count

        try url.setQuery(with: queryItems, mergePolicy: .overwrite)

        #expect(url.queryItems.count == expectedURLCount)
    }
}
