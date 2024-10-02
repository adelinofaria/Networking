//
//  NetworkingDecodingTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct NetworkingDecodingTests {

    // MARK: Tests

    @Test("decodeLogic<T: NetworkDecodable>(data:httpURLResponse:)")
    func decodeLogic() async throws {

        let obj: DecodableObject
        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        obj = try await Networking().decodeLogic(data: DecodableObject.sampleData, httpURLResponse: httpURLResponse)

        #expect(obj.a == true)
        #expect(obj.b == 1)
        #expect(obj.c == "abc")
    }

    @Test("decodeLogic<T: NetworkDecodable>(data:httpURLResponse:) Wrong StatusCode")
    func decodeLogicWrongStatusCode() async throws {

        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 500,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        do {

            let _: DecodableObject = try await Networking().decodeLogic(data: DecodableObject.sampleData,
                                                                        httpURLResponse: httpURLResponse)

            Issue.record("Expecting a throw")

        } catch .unexpectedStatusCode(data: _, response: let response) {

            #expect(response.statusCode == 500)

        } catch {
            Issue.record("Wrong expected catch")
        }
    }

    @Test("decodeLogic<T: ThrowDecodableObject>(data:httpURLResponse:)")
    func decodeLogicThrow() async throws {

        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        do {

            let _: ThrowDecodableObject = try await Networking().decodeLogic(data: Data(),
                                                                             httpURLResponse: httpURLResponse)

            Issue.record("Expecting a throw")

        } catch {

            #expect(error != nil)
        }
    }

    @Test("decodeLogic<T: DecodableObject, E: NetworkDecodable>(data:httpURLResponse:)")
    func decodeLogicResult() async throws {

        let obj: Result<DecodableObject, DecodableErrorObject>
        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        obj = try await Networking().decodeLogic(data: DecodableObject.sampleData, httpURLResponse: httpURLResponse)

        if case .success(let success) = obj {

            #expect(success.a == true)
            #expect(success.b == 1)
            #expect(success.c == "abc")
        } else {
            Issue.record("Failed to parse object")
        }
    }

    @Test("decodeLogic<T: ThrowDecodableObject, E: NetworkDecodable>(data:httpURLResponse:)")
    func decodeLogicResultThrow() async throws {

        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        do {

            let _: Result<ThrowDecodableObject, DecodableErrorObject> = try await Networking().decodeLogic(data: Data(),
                                                                                                           httpURLResponse: httpURLResponse)

            Issue.record("Expecting a throw")

        } catch {

            #expect(error != nil)
        }
    }

    @Test("decodeLogic<T: NetworkDecodable, E: DecodableErrorObject>(data:httpURLResponse:)")
    func decodeLogicResultError() async throws {

        let obj: Result<DecodableObject, DecodableErrorObject>
        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 500,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        obj = try await Networking().decodeLogic(data: Data(), httpURLResponse: httpURLResponse)


        if case .failure(let failure) = obj {

            #expect(failure == DecodableErrorObject())

        } else {

            Issue.record("Expected object parsed instead of expected error object")
        }
    }

    @Test("decodeLogic<T: NetworkDecodable, E: ThrowDecodableErrorObject>(data:httpURLResponse:)")
    func decodeLogicResultErrorThrow() async throws {

        let httpURLResponse = try #require(HTTPURLResponse(url: .sample,
                                                           statusCode: 500,
                                                           httpVersion: nil,
                                                           headerFields: nil))

        do {

            let _: Result<DecodableObject, ThrowDecodableErrorObject> = try await Networking().decodeLogic(data: Data(),
                                                                                                           httpURLResponse: httpURLResponse)

            Issue.record("Expecting a throw")

        } catch {

            #expect(error != nil)
        }
    }
}
