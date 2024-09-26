//
//  HTTPRequest.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public typealias Payload = [PayloadType]

public enum HTTPRequest {

    case get(url: URL, payload: Payload? = nil)
    case head(url: URL, payload: Payload? = nil)
    case post(url: URL, payload: Payload? = nil)
    case put(url: URL, payload: Payload? = nil)
    case delete(url: URL, payload: Payload? = nil)
    case patch(url: URL, payload: Payload? = nil)

    public var rawValue: String {
        switch self {
        case .get:
            "GET"
        case .head:
            "HEAD"
        case .post:
            "POST"
        case .put:
            "PUT"
        case .delete:
            "DELETE"
        case .patch:
            "PATCH"
        }
    }
}

extension HTTPRequest {

    var url: URL {
        switch self {
        case .get(url: let url, payload: _):
            url
        case .head(url: let url, payload: _):
            url
        case .post(url: let url, payload: _):
            url
        case .put(url: let url, payload: _):
            url
        case .delete(url: let url, payload: _):
            url
        case .patch(url: let url, payload: _):
            url
        }
    }

    var payload: Payload? {
        switch self {
        case .get(url: _, payload: let payload):
            payload
        case .head(url: _, payload: let payload):
            payload
        case .post(url: _, payload: let payload):
            payload
        case .put(url: _, payload: let payload):
            payload
        case .delete(url: _, payload: let payload):
            payload
        case .patch(url: _, payload: let payload):
            payload
        }
    }

    func urlRequest(with config: Config) async throws -> URLRequest {

        let url = self.url
        let payloadTypes = self.payload

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = self.rawValue

        if let payloadTypes {
            for payloadType in payloadTypes {
                switch payloadType {
                case .queryString(let queryString):
                    try urlRequest.setQueryString(with: queryString, mergePolicy: config.queryItemMergePolicy)
                case .headers(let headers):
                    // add user-agent here
                    // maybe have shared headers in config and merge them here
                    urlRequest.setHeaders(headers: headers)
                case .body(let object):
                    try await urlRequest.setBody(object: object)
                }
            }
        }

        return urlRequest
    }
}
