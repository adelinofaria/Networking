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

    @Test func requestData() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path1?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: Data())

        let result: (Data, URLResponse) = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test func requestNoResult() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path2?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: Data())

        let result: NoResult = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test func requestDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path3?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: DecodableObject.sampleObjectData())

        let result: DecodableObject = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test func requestResultNoResult() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path4?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: Data())

        let result: Result<NoResult, NoError> = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test func requestResultDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path5?query=item"))

        await Self.urlSessionMock.registerMock(url: url, data: DecodableObject.sampleObjectData())

        let result: Result<DecodableObject, NoError> = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test func cancelation() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path6?query=item"))

        let task = Task {

            do {
                let _: NoResult = try await self.networking.request(.get(url: url))
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
