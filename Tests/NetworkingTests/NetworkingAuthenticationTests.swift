//
//  NetworkingAuthenticationTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct NetworkingAuthenticationTests {

    // MARK: Tests

    @Test
    func authenticationLogicSuccess() async throws {

        let networking = Networking(authentication: AuthenticatorTest())

        let urlRequest = try await networking.authenticationLogic(urlRequest: .init(url: .sample))

        #expect(urlRequest.allHTTPHeaderFields?["Auth"] == "token")
    }

    @Test
    func authenticationLogicThrow() async throws {

        let networking = Networking(authentication: NetworkAuthenticationThrow())

        do {
            let _ = try await networking.authenticationLogic(urlRequest: .init(url: .sample))

            Issue.record("Expecting throw")
        } catch {

            #expect(error != nil)
        }
    }
}

struct AuthenticatorTest: NetworkAuthentication {
    func authenticate(urlRequest: URLRequest) async throws(NetworkAuthenticationError) -> URLRequest {
        var urlRequest = urlRequest
        var allHTTPHeaderFields = urlRequest.allHTTPHeaderFields ?? [:]

        allHTTPHeaderFields["Auth"] = "token"

        urlRequest.allHTTPHeaderFields = allHTTPHeaderFields

        return urlRequest
    }
}
