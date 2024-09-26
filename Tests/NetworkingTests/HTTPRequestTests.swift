//
//  HTTPRequestTests.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

extension URL {
    static var sample = URL(string: "https://host.domain/path?q=abc")!
}

@Suite struct HTTPRequestTests {

    // MARK: Setup

    static let allMethods: [HTTPRequest] = [
        .get(url: .sample),
        .head(url: .sample),
        .post(url: .sample),
        .put(url: .sample),
        .delete(url: .sample),
        .patch(url: .sample)
    ]

    static let allMethodStrings = [
        "GET",
        "HEAD",
        "POST",
        "PUT",
        "DELETE",
        "PATCH"
    ]

    static let allPayloads: [Payload] = [
        [],
        [.queryString([.init(name: "a", value: "1")])],
        [.headers([.init(name: "b", value: "2")])],
        [.body(EncodableObject.sample)],
        [.queryString([.init(name: "a", value: "1")]), .headers([.init(name: "b", value: "2")]), .body(EncodableObject.sample)],
    ]

    static let allPayloadsExpectations = [
        (URL.sample, [:], nil),
        (URL(string: "https://host.domain/path?q=abc&a=1")!, [:], nil),
        (URL.sample, ["b": "2"], nil),
        (URL.sample, ["Content-Type": "application/json"], EncodableObject.sampleData),
        (URL(string: "https://host.domain/path?q=abc&a=1")!, ["b": "2", "Content-Type": "application/json"], EncodableObject.sampleData),
    ]

    // MARK: Tests

    @Test("All http methods with no payload", arguments: zip(Self.allMethods, Self.allMethodStrings))
    func urlRequestNoPayload(httpRequest: HTTPRequest, method: String) async throws {

        #expect(httpRequest.rawValue == method)
        #expect(httpRequest.url == .sample)
        #expect(httpRequest.payload == nil)

        let urlRequest = try await httpRequest.urlRequest(with: .init())

        #expect(urlRequest.httpMethod == method)
        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == [:])
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All payloads with a get", arguments: zip(Self.allPayloads, Self.allPayloadsExpectations))
    func urlRequestNoPayload(payload: Payload, expectation: (URL, [String : String], Data?)) async throws {

        let httpRequest = HTTPRequest.get(url: .sample, payload: payload)

        #expect(httpRequest.url == .sample)
        #expect(httpRequest.payload == payload)

        let urlRequest = try await httpRequest.urlRequest(with: .init())

        #expect(urlRequest.url == expectation.0)
        #expect(urlRequest.allHTTPHeaderFields == expectation.1)
        #expect(urlRequest.httpBody?.count == expectation.2?.count)
    }
}
