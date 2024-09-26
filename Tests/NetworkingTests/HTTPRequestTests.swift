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

struct HTTPRequestTests {

    // MARK: Setup

    let url = URL(string: "https://domain.toplevel/path?query=item")

    // MARK: Tests

    @Test func urlRequestGetNoArgs() async throws {

        let url = try #require(self.url)
        let request: HTTPRequest = .get(url: url)

        let urlRequest = try request.urlRequest(with: .init())

        #expect(request.url == url)
        #expect(request.payload == nil)
        #expect(urlRequest.url == url)
    }
}
