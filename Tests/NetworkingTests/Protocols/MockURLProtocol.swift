//
//  MockURLProtocol.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing

protocol MockURLProtocolDelegate {
    func processRequest(with task: URLSessionTask) async throws -> (URLResponse, Data)
}

final class MockURLProtocol: URLProtocol {

    static var delegate: MockURLProtocolDelegate?

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

        Task {
            do {
                let (response, data) = try await delegate.processRequest(with: task)

                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            } catch {
                Issue.record("MockURLProtocol - Error trying to fetch mock for corresponding URLSessionTask")
            }
        }
    }
    override func stopLoading() {

    }
}

final actor URLSessionMock: MockURLProtocolDelegate {

    enum URLSessionMockError: Error {
        case unknown
        case mockNotFound
    }

    struct MockEntry {

        let url: URL
        let data: Data
        let httpResponse: Bool
    }

    var registeredEntries: [MockEntry] = []

    func registerMock(url: URL, data: Data, httpResponse: Bool = true) {

        self.registeredEntries.append(.init(url: url, data: data, httpResponse: httpResponse))
    }

    // MARK: MockURLProtocolDelegate

    func processRequest(with task: URLSessionTask) async throws -> (URLResponse, Data) {

        guard let url = task.currentRequest?.url,
              let entry = self.registeredEntries.first(where: { $0.url == url }) else {
            throw URLSessionMockError.mockNotFound
        }

        let response: URLResponse

        if entry.httpResponse {

            response = HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: entry.data.count, textEncodingName: nil)

        } else {

            response = URLResponse(url: url, mimeType: nil, expectedContentLength: entry.data.count, textEncodingName: nil)
        }

        return (response, entry.data)
    }
}
