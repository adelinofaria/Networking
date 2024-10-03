//
//  MockURLProtocol.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing

protocol MockURLProtocolDelegate: Sendable {
    func processRequest(with task: URLSessionTask) async throws -> (URLResponse, Data)
}

final class MockURLProtocol: URLProtocol {

    nonisolated(unsafe) static var delegate: MockURLProtocolDelegate?

    override class func canInit(with task: URLSessionTask) -> Bool {
        // FIXME: check schema
        // FIXME: check domain
        // FIXME: check path
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {

        return request
    }

    override func startLoading() {
        guard let task = self.task else {
            Issue.record("MockURLProtocol - Error trying to get hold of the URLSessionTask")
            return
        }
        guard let delegate = Self.delegate else {
            Issue.record("MockURLProtocol - MockURLProtocolDelegate not set")
            return
        }

        self.processRequest(client: self.client, task: task, delegate: delegate)
    }
    override func stopLoading() {

    }
}

extension MockURLProtocol : @unchecked Sendable {

    func processRequest(client: (any URLProtocolClient)?, task: URLSessionTask, delegate: any MockURLProtocolDelegate) {

        Task {
            do {
                let (response, data) = try await delegate.processRequest(with: task)

                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                Issue.record("MockURLProtocol - Error trying to fetch mock for corresponding URLSessionTask")
            }
        }
    }
}

final actor URLSessionMock: MockURLProtocolDelegate {

    enum URLSessionMockError: Error {
        case unknown
        case mockNotFound
    }

    struct MockEntry {

        let url: URL
        let statusCode: Int
        let data: Data
        let httpResponse: Bool
    }

    static let shared: URLSessionMock = {
        let mock = URLSessionMock()

        MockURLProtocol.delegate = mock

        return mock
    }()

    var registeredEntries: [MockEntry] = []

    func registerMock(url: URL, statusCode: Int, data: Data, httpResponse: Bool = true) {

        self.registeredEntries.append(.init(url: url, statusCode: statusCode, data: data, httpResponse: httpResponse))
    }

    // MARK: MockURLProtocolDelegate

    func processRequest(with task: URLSessionTask) async throws -> (URLResponse, Data) {

        guard let url = task.currentRequest?.url,
              let entry = self.registeredEntries.first(where: { $0.url == url }) else {
            throw URLSessionMockError.mockNotFound
        }

        let response: URLResponse

        if entry.httpResponse {

            if let httpURLResponse = HTTPURLResponse(url: url,
                                                     statusCode: entry.statusCode,
                                                     httpVersion: nil,
                                                     headerFields: nil) {
                response = httpURLResponse
            } else {
                response = HTTPURLResponse(url: url,
                                           mimeType: nil,
                                           expectedContentLength: entry.data.count,
                                           textEncodingName: nil)
            }

        } else {

            response = URLResponse(url: url,
                                   mimeType: nil,
                                   expectedContentLength: entry.data.count,
                                   textEncodingName: nil)
        }

        return (response, entry.data)
    }
}
