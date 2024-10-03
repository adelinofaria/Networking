//
//  HTTPResponseTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct HTTPResponseTests {

    // MARK: Tests

    @Test("init(result: .success)")
    func initEmptySuccess() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .success(DecodableObject.sample),
            httpStatusCode: 123,
            httpHeaders: [:]
        )

        #expect(httpResponse.result == .success(DecodableObject.sample))
        #expect(httpResponse.httpStatusCode == 123)
        #expect(httpResponse.httpHeaders?.keys == [:].keys)
    }

    @Test("init(result: .failure)")
    func initEmptyFailure() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .failure(DecodableErrorObject()),
            httpStatusCode: 123,
            httpHeaders: [:]
        )

        #expect(httpResponse.result == .failure(DecodableErrorObject()))
        #expect(httpResponse.httpStatusCode == 123)
        #expect(httpResponse.httpHeaders?.keys == [:].keys)
    }

    @Test("init(result:httpStatusCode:httpHeaders:)")
    func initHeaders() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .success(DecodableObject.sample),
            httpStatusCode: 321,
            httpHeaders: ["k1": "v1", "k2": "v2"]
        )

        #expect(httpResponse.result == .success(DecodableObject.sample))
        #expect(httpResponse.httpStatusCode == 321)
        #expect(httpResponse.httpHeaders?.keys == ["k1": "v1", "k2": "v2"].keys)
    }

    @Test("var resultObject: T? - .success")
    func resultObjectSuccess() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .success(DecodableObject.sample),
            httpStatusCode: 123,
            httpHeaders: [:]
        )

        #expect(httpResponse.resultObject == DecodableObject.sample)
    }

    @Test("var resultObject: T? - .failure")
    func resultObjectFailure() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .failure(DecodableErrorObject()),
            httpStatusCode: 123,
            httpHeaders: [:]
        )

        #expect(httpResponse.resultObject == nil)
    }

    @Test("var resultError: E? - .success")
    func resultErrorSuccess() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .success(DecodableObject.sample),
            httpStatusCode: 123,
            httpHeaders: [:]
        )

        #expect(httpResponse.resultError == nil)
    }

    @Test("var resultError: E? - .failure")
    func resultErrorFailure() async throws {

        let httpResponse = HTTPResponse<DecodableObject, DecodableErrorObject>(
            result: .failure(DecodableErrorObject()),
            httpStatusCode: 123,
            httpHeaders: [:]
        )

        #expect(httpResponse.resultError == DecodableErrorObject())
    }
}
