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

@Suite
struct HTTPRequestTests {

    // MARK: Setup

    static let allMethods: [HTTPRequest<None, NoneError>] = [
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
        (["Content-Type": "application/test"], EncodableObject(a: true, b: 1, c: "abc")),
        (["Content-Type": "application/test"], EncodableObject(a: true, b: 1, c: "abc")),
        ([:], nil),
        (["Content-Type": "application/test"], EncodableObject(a: true, b: 1, c: "abc"))
    ]

    // MARK: Tests

    @Test("All http methods with no payload", arguments: zip(Self.allMethods, Self.allMethodStrings))
    func urlRequestNoPayload(httpRequest: HTTPRequest<None, NoneError>, method: String) async throws {

        #expect(httpRequest.method.rawValue == method)
        #expect(httpRequest.url == .sample)
        #expect(httpRequest.query == nil)
        #expect(httpRequest.headers == nil)
        #expect(httpRequest.body == nil)

        let urlRequest = try await httpRequest.urlRequest(with: .init())

        let expectedHeaders = await [:].mergedDefaultHeaders()

        #expect(urlRequest.httpMethod == method)
        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == expectedHeaders)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All methods with queryString", arguments: Self.allMethods)
    func urlRequestWithQuery(httpRequest: HTTPRequest<None, NoneError>) async throws {

        let query: [HTTPQueryItem] = [.init(name: "a", value: "1")]

        let payloadHTTPRequest = httpRequest.setting(query: query)

        #expect(payloadHTTPRequest.url == .sample)
        #expect(payloadHTTPRequest.query == query)
        #expect(payloadHTTPRequest.headers == nil)
        #expect(payloadHTTPRequest.body == nil)

        let urlRequest = try await payloadHTTPRequest.urlRequest(with: .init())

        let expectedHeaders = await [:].mergedDefaultHeaders()

        #expect(urlRequest.url == URL(string: "https://host.domain/path?q=abc&a=1"))
        #expect(urlRequest.allHTTPHeaderFields == expectedHeaders)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All methods with headers", arguments: Self.allMethods)
    func urlRequestWithHeaders(httpRequest: HTTPRequest<None, NoneError>) async throws {

        let headers = ["b": "2"]

        let payloadHTTPRequest = httpRequest.setting(headers: headers)

        #expect(payloadHTTPRequest.url == .sample)
        #expect(payloadHTTPRequest.query == nil)
        #expect(payloadHTTPRequest.headers == headers)
        #expect(payloadHTTPRequest.body == nil)

        let urlRequest = try await payloadHTTPRequest.urlRequest(with: .init())

        let expectedHeaders = await ["b": "2"].mergedDefaultHeaders()

        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == expectedHeaders)
        #expect(urlRequest.httpBody == nil)
    }

    @Test("All methods with body", arguments: zip(Self.allMethods, Self.encodableBodyExpectation))
    func urlRequestWithBody(httpRequest: HTTPRequest<None, NoneError>, expectation: ([String: String], (any NetworkEncodable)?)) async throws {

        let body = EncodableObject(a: true, b: 1, c: "abc")

        let payloadHTTPRequest = httpRequest.setting(body: body)

        #expect(payloadHTTPRequest.url == .sample)
        #expect(payloadHTTPRequest.query == nil)
        #expect(payloadHTTPRequest.headers == nil)
        #expect((payloadHTTPRequest.body == nil) == (expectation.1 == nil))

        let urlRequest = try await payloadHTTPRequest.urlRequest(with: .init())

        let expectedHeaders = await expectation.0.mergedDefaultHeaders()
        let expectedByteCount = try? await expectation.1?.encode().count

        #expect(urlRequest.url == .sample)
        #expect(urlRequest.allHTTPHeaderFields == expectedHeaders)
        #expect(urlRequest.httpBody?.count == expectedByteCount)
    }

    @Test("urlRequest(with:) throws")
    func urlRequestThrows() async throws {

        let httpRequest: HTTPRequest<None, NoneError> = .post(url: .sample)
        let body = ThrowEncodableObject()
        let payloadHTTPRequest = httpRequest.setting(body: body)

        do {
            let _ = try await payloadHTTPRequest.urlRequest(with: .init())

            Issue.record("Expected thrown error")
        } catch .encodable(error: let encodableError) {
            #expect(encodableError != nil)
        } catch {
            Issue.record("Wrong expected thrown error")
        }
    }
}

// MARK: Helper Functions

extension Dictionary where Key == String, Value == String {

    func mergedDefaultHeaders() async -> [String: String] {

        let defaultHeaders = [
            "User-Agent": await HTTPConstants.userAgent
        ]

        let merged = self.merging(defaultHeaders) { $1 }

        return merged
    }
}
