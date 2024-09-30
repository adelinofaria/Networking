//
//  NetworkingTests.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct NetworkingTests {

    // MARK: Setup

    static let urlSessionMock: URLSessionMock = .init()

    var networking: Networking {

        let urlSessionConfiguration = URLSessionConfiguration.ephemeral

        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        MockURLProtocol.delegate = Self.urlSessionMock

        let networking = Networking(urlSession: URLSession(configuration: urlSessionConfiguration))

        return networking
    }

    // MARK: Tests

    @Test
    func requestPlumbing() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path1?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: Data())

        let result: (Data, URLResponse) = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test
    func requestNone() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path2?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: Data())

        let _: None = try await self.networking.request(.get(url: url))
    }

    @Test
    func requestDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path3?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: DecodableObject.sampleData)

        let result: DecodableObject = try await self.networking.request(.get(url: url))

        #expect(result.a == true)
        #expect(result.b == 1)
        #expect(result.c == "abc")
    }

    @Test
    func requestResultNone() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path4?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: Data())

        let _: Result<None, NoneError> = try await self.networking.request(.get(url: url))
    }

    @Test
    func requestResultDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path5?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: DecodableObject.sampleData)

        let result: Result<DecodableObject, NoneError> = try await self.networking.request(.get(url: url))

        switch result {
        case .success(let result):
            #expect(result.a == true)
            #expect(result.b == 1)
            #expect(result.c == "abc")
        case .failure(let error):
            Issue.record(error)
        }
    }

    @Test
    func requestHTTPResponseDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path3?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: DecodableObject.sampleData)

        let httpResponse: HTTPResponse<DecodableObject, NoneError> = try await self.networking.request(.get(url: url))

        switch httpResponse.result {
        case .success(let result):
            #expect(result.a == true)
            #expect(result.b == 1)
            #expect(result.c == "abc")
        case .failure(let error):
            Issue.record(error)
        }

        #expect(httpResponse.httpStatusCode == 200)
        #expect(httpResponse.httpHeaders.count == 0)
    }

    @Test
    func cancelation() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path6?query=item"))

        let task = Task {

            do {
                let _: None = try await self.networking.request(.get(url: url))
                return false
            } catch is NetworkingError {
                return false
            } catch is CancellationError {
                return true
            }
        }

        task.cancel()

        let taskThrows = try await task.value

        #expect(taskThrows == true)
    }
}


/*
 Testing checklist
 [ ] Networking public interfaces
 [ ] Networking authentication logic
 [ ] Netowkring decoding logic
 [ ] Netowkring request logic (success, failure, throwing, cancelation
 [ ] Config
 [ ] Extensions Array+URLQueryItem
 [ ] Extensions URL+HTTPQueryItem
 [ ] Extensions URLRequest+Mutating
 [ ] HTTPHeader
 [ ] HTTPQueryItem
 [ ] HTTPRequest
 [ ] HTTPResponse
 [ ] all throwables should be testable
 */
