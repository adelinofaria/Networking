//
//  DataNetworkCodableTests.swift
//  Networking
//
//  Created by Adelino Faria on 02/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct DataNetworkCodableTests {

    // MARK: Tests

    @Test("decode(:data)")
    func decode() async throws {

        let data = try #require("abc".data(using: .utf8))

        let decodedData = try await Data.decode(data: data)

        #expect(decodedData == data)
        #expect(String(data: decodedData, encoding: .utf8) == "abc")
    }

    @Test("var contentType")
    func contentType() async throws {

        let data = try #require("abc".data(using: .utf8))

        #expect(data.contentType == nil)
    }

    @Test("encode()")
    func encode() async throws {

        let data = try #require("abc".data(using: .utf8))

        let encodedData = try await data.encode()

        #expect(encodedData == data)
        #expect(String(data: encodedData, encoding: .utf8) == "abc")
    }
}
