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

    var networking: Networking {

        let urlSessionConfiguration = URLSessionConfiguration.ephemeral

        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        let networking = Networking(urlSession: URLSession(configuration: urlSessionConfiguration))

        return networking
    }

    // MARK: Tests

    @Test
    func requestPlumbing() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path1?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: Data())

        let result: (Data, URLResponse) = try await self.networking.request(.get(url: url))

        #expect(result != nil)
    }

    @Test
    func requestNone() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path2?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: Data())

        let _: None = try await self.networking.request(.get(url: url))
    }

    @Test
    func requestDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path3?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: DecodableObject.sampleData)

        let result: DecodableObject = try await self.networking.request(.get(url: url))

        #expect(result.a == true)
        #expect(result.b == 1)
        #expect(result.c == "abc")
    }

    @Test
    func requestResultNone() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path4?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: Data())

        let _: Result<None, NoneError> = try await self.networking.request(.get(url: url))
    }

    @Test
    func requestResultDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path5?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: DecodableObject.sampleData)

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
    func requestResultNoneError() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path6?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 500, data: DecodableObject.sampleData)

        let result: Result<DecodableObject, NoneError> = try await self.networking.request(.get(url: url))

        switch result {
        case .success:
            Issue.record("Expected .failure")
        case .failure(let error):
            #expect(error != nil)
        }
    }

    @Test
    func requestHTTPResponseDecodable() async throws {

        let url = try #require(URL(string: "https://domain.toplevel/path7?query=item"))

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: DecodableObject.sampleData)

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

        let url = try #require(URL(string: "https://domain.toplevel/path8?query=item"))

        let task = Task {

            do {
                let _: None = try await self.networking.request(.get(url: url))
                return false
            } catch NetworkingError.canceled {
                return true
            } catch {
                return false
            }
        }

        task.cancel()

        #expect(await task.value == true)
    }

    @Test
    func requestAuthThrows() async throws {
        do {
            let _: None = try await Networking(authentication: NetworkAuthenticationThrow()).request(.get(url: .sample))

            Issue.record("Expected thrown error")
        } catch NetworkingError.authentication(error: let authenticationError) {
            #expect(authenticationError != nil)
        } catch {
            Issue.record("Wrong expected thrown error")
        }
    }

    @Test
    func requestDecodeThrows() async throws {

        let url = try URL.random()

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: Data())

        do {
            let _: ThrowDecodableObject = try await self.networking.request(.get(url: url))

            Issue.record("Expected thrown error")
        } catch NetworkingError.decodable(error: let decodeError) {
            #expect(decodeError != nil)
        } catch {
            Issue.record("Wrong expected thrown error")
        }
    }

    @Test
    func requestDecodeResultThrows() async throws {

        let url = try URL.random()

        await URLSessionMock.shared.registerMock(url: url, statusCode: 200, data: Data())

        do {
            let _: Result<ThrowDecodableObject, NoneError> = try await self.networking.request(.get(url: url))

            Issue.record("Expected thrown error")
        } catch NetworkingError.decodable(error: let decodeError) {
            #expect(decodeError != nil)
        } catch {
            Issue.record("Wrong expected thrown error")
        }
    }
}
