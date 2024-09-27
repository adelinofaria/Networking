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

    static let encodableBodyExpectation: [([String: String], (any NetworkEncodable)?)] = [
        ([:], nil),
        ([:], nil),
        (["Content-Type": "application/json"], EncodableObject(a: true, b: 1, c: "abc")),
        (["Content-Type": "application/json"], EncodableObject(a: true, b: 1, c: "abc")),
        ([:], nil),
        (["Content-Type": "application/json"], EncodableObject(a: true, b: 1, c: "abc"))
    ]

    // MARK: Tests

    @Test("All http methods with no payload", arguments: zip(Self.allMethods, Self.allMethodStrings))
    func urlRequestNoPayload(httpRequest: HTTPRequest, method: String) async throws {

        #expect(httpRequest.rawValue == method)
        #expect(httpRequest.url == .sample)
        #expect(httpRequest.query == nil)
        #expect(httpRequest.headers == nil)
        #expect(httpRequest.body == nil)

        let urlRequest = try await httpRequest.urlRequest(with: .init())

        #expect(urlRequest.httpMethod == method)
        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == [:])
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All methods with queryString", arguments: Self.allMethods)
    func urlRequestWithQuery(httpRequest: HTTPRequest) async throws {

        let query: [QueryItem] = [.init(name: "a", value: "1")]

        let payloadHTTPRequest = httpRequest.setting(query: query)

        #expect(payloadHTTPRequest.url == .sample)
        #expect(payloadHTTPRequest.query == query)
        #expect(payloadHTTPRequest.headers == nil)
        #expect(payloadHTTPRequest.body == nil)

        let urlRequest = try await payloadHTTPRequest.urlRequest(with: .init())

        #expect(urlRequest.url == URL(string: "https://host.domain/path?q=abc&a=1"))
        #expect(urlRequest.allHTTPHeaderFields == [:])
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All methods with headers", arguments: Self.allMethods)
    func urlRequestWithHeaders(httpRequest: HTTPRequest) async throws {

        let headers: [HTTPHeader] = [.init(name: "b", value: "2")]

        let payloadHTTPRequest = httpRequest.setting(headers: headers)

        #expect(payloadHTTPRequest.url == .sample)
        #expect(payloadHTTPRequest.query == nil)
        #expect(payloadHTTPRequest.headers == headers)
        #expect(payloadHTTPRequest.body == nil)

        let urlRequest = try await payloadHTTPRequest.urlRequest(with: .init())

        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == ["b": "2"])
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All methods with body", arguments: zip(Self.allMethods, Self.encodableBodyExpectation))
    func urlRequestWithBody(httpRequest: HTTPRequest, expectation: ([String: String], (any NetworkEncodable)?)) async throws {

        let body = EncodableObject(a: true, b: 1, c: "abc")

        let payloadHTTPRequest = httpRequest.setting(body: body)

        #expect(payloadHTTPRequest.url == .sample)
        #expect(payloadHTTPRequest.query == nil)
        #expect(payloadHTTPRequest.headers == nil)
        #expect((payloadHTTPRequest.body == nil) == (expectation.1 == nil))

        let urlRequest = try await payloadHTTPRequest.urlRequest(with: .init())
        let expectedByteCount = try? await expectation.1?.encode().count

        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == expectation.0)
        #expect(urlRequest.httpBody?.count == expectedByteCount)
    }
}


extension HTTPRequest {

    func setting(query: [QueryItem]) -> Self {

        switch self {

        case .get(url: let url, query: _, headers: let headers):
            .get(url: url, query: query, headers: headers)
        case .head(url: let url, query: _, headers: let headers):
            .head(url: url, query: query, headers: headers)
        case .post(url: let url, query: _, headers: let headers, body: let body):
            .post(url: url, query: query, headers: headers, body: body)
        case .put(url: let url, query: _, headers: let headers, body: let body):
            .put(url: url, query: query, headers: headers, body: body)
        case .delete(url: let url, query: _, headers: let headers):
            .delete(url: url, query: query, headers: headers)
        case .patch(url: let url, query: _, headers: let headers, body: let body):
            .patch(url: url, query: query, headers: headers, body: body)
        }
    }

    func setting(headers: [HTTPHeader]) -> Self {

        switch self {

        case .get(url: let url, query: let query, headers: _):
            .get(url: url, query: query, headers: headers)
        case .head(url: let url, query: let query, headers: _):
            .head(url: url, query: query, headers: headers)
        case .post(url: let url, query: let query, headers: _, body: let body):
            .post(url: url, query: query, headers: headers, body: body)
        case .put(url: let url, query: let query, headers: _, body: let body):
            .put(url: url, query: query, headers: headers, body: body)
        case .delete(url: let url, query: let query, headers: _):
            .delete(url: url, query: query, headers: headers)
        case .patch(url: let url, query: let query, headers: _, body: let body):
            .patch(url: url, query: query, headers: headers, body: body)
        }
    }

    func setting(body: any NetworkEncodable) -> Self {

        switch self {

        case .get(url: let url, query: let query, headers: let headers):
            .get(url: url, query: query, headers: headers)
        case .head(url: let url, query: let query, headers: let headers):
            .head(url: url, query: query, headers: headers)
        case .post(url: let url, query: let query, headers: let headers, body: _):
            .post(url: url, query: query, headers: headers, body: body)
        case .put(url: let url, query: let query, headers: let headers, body: _):
            .put(url: url, query: query, headers: headers, body: body)
        case .delete(url: let url, query: let query, headers: let headers):
            .delete(url: url, query: query, headers: headers)
        case .patch(url: let url, query: let query, headers: let headers, body: _):
            .patch(url: url, query: query, headers: headers, body: body)
        }
    }
}
