//
//  HTTPRequest.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public enum HTTPRequest {

    case get(url: URL, query: [QueryItem]? = nil, headers: [HTTPHeader]? = nil)
    case head(url: URL, query: [QueryItem]? = nil, headers: [HTTPHeader]? = nil)
    case post(url: URL, query: [QueryItem]? = nil, headers: [HTTPHeader]? = nil, body: (any NetworkEncodable)? = nil)
    case put(url: URL, query: [QueryItem]? = nil, headers: [HTTPHeader]? = nil, body: (any NetworkEncodable)? = nil)
    case delete(url: URL, query: [QueryItem]? = nil, headers: [HTTPHeader]? = nil)
    case patch(url: URL, query: [QueryItem]? = nil, headers: [HTTPHeader]? = nil, body: (any NetworkEncodable)? = nil)

    var rawValue: String {
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
        case .get(url: let url, query: _, headers: _):
            url
        case .head(url: let url, query: _, headers: _):
            url
        case .post(url: let url, query: _, headers: _, body: _):
            url
        case .put(url: let url, query: _, headers: _, body: _):
            url
        case .delete(url: let url, query: _, headers: _):
            url
        case .patch(url: let url, query: _, headers: _, body: _):
            url
        }
    }

    var query: [QueryItem]? {

        switch self {
        case .get(url: _, query: let query, headers: _):
            query
        case .head(url: _, query: let query, headers: _):
            query
        case .post(url: _, query: let query, headers: _, body: _):
            query
        case .put(url: _, query: let query, headers: _, body: _):
            query
        case .delete(url: _, query: let query, headers: _):
            query
        case .patch(url: _, query: let query, headers: _, body: _):
            query
        }
    }

    var headers: [HTTPHeader]? {

        switch self {
        case .get(url: _, query: _, headers: let headers):
            headers
        case .head(url: _, query: _, headers: let headers):
            headers
        case .post(url: _, query: _, headers: let headers, body: _):
            headers
        case .put(url: _, query: _, headers: let headers, body: _):
            headers
        case .delete(url: _, query: _, headers: let headers):
            headers
        case .patch(url: _, query: _, headers: let headers, body: _):
            headers
        }
    }

    var body: (any NetworkEncodable)? {

        switch self {
        case .get(url: _, query: _, headers: _):
            nil
        case .head(url: _, query: _, headers: _):
            nil
        case .post(url: _, query: _, headers: _, body: let body):
            body
        case .put(url: _, query: _, headers: _, body: let body):
            body
        case .delete(url: _, query: _, headers: _):
            nil
        case .patch(url: _, query: _, headers: _, body: let body):
            body
        }
    }

    func urlRequest(with config: Config) async throws -> URLRequest {

        var urlRequest = URLRequest(url: self.url)

        urlRequest.httpMethod = self.rawValue
        urlRequest.setValue(await HTTPConstants.userAgent, forHTTPHeaderField: HTTPConstants.userAgentHeaderKey)

        // FIXME: maybe have shared headers in config and add them here

        if let query = self.query {
            try urlRequest.setQuery(with: query, mergePolicy: config.queryItemMergePolicy)
        }

        if let headers = self.headers {
            urlRequest.setHeaders(headers: headers)
        }

        if let body = self.body {
            try await urlRequest.setBody(object: body)
        }

        return urlRequest
    }
}
