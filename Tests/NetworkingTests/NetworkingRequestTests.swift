//
//  NetworkingRequestTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct NetworkingRequestTests {

    // MARK: Setup

    var networking: Networking {

        let urlSessionConfiguration = URLSessionConfiguration.ephemeral

        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        let networking = Networking(urlSession: URLSession(configuration: urlSessionConfiguration))

        return networking
    }

    // MARK: Tests

    @Test("requestLogic(urlRequest:)")
    func requestLogic() async throws {

        let stringData = try #require("abc".data(using: .utf8))

        await URLSessionMock.shared.registerMock(url: .sample, data: stringData)

        let (data, response) = try await self.networking.requestLogic(urlRequest: .init(url: .sample))

        #expect(data == stringData)
        #expect(response.statusCode == 200)
    }

    @Test("requestLogic(urlRequest:).cancel()")
    func requestLogicCancel() async throws {

        let stringData = try #require("abc".data(using: .utf8))

        await URLSessionMock.shared.registerMock(url: .sample, data: stringData)

        let task = Task {
            do {
                let _ = try await self.networking.requestLogic(urlRequest: .init(url: .sample))
            } catch NetworkingError.canceled {
                return true
            } catch {
                return false
            }

            return false
        }

        task.cancel()

        #expect(await task.value == true)
    }

    @Test("requestLogic(urlRequest:) throws")
    func requestLogicThrow() async throws {

        // Not mocking this request, forcing a Foundation throw that we expect

        do {
            let _ = try await Networking().requestLogic(urlRequest: .init(url: .random()))

            Issue.record("Expecting a thrown error")

        } catch NetworkingError.urlSessionError(error: let error) {

            #expect(error != nil)

        } catch {

            Issue.record("Wrong expected thrown error")
        }
    }

    @Test("requestLogic(urlRequest:) invalid HTTPURLResponse")
    func requestLogicInvalidHTTPURLResponse() async throws {

        let url = try #require(try URL.random())
        let stringData = try #require("abc".data(using: .utf8))

        await URLSessionMock.shared.registerMock(url: url, data: stringData, httpResponse: false)

        do {
            let _ = try await self.networking.requestLogic(urlRequest: .init(url: url))

            Issue.record("Expecting a thrown error")

        } catch NetworkingError.invalidResponse(data: let data, response: _) {

            #expect(data.count == stringData.count)

        } catch {

            Issue.record("Wrong expected thrown error")
        }
    }
}
