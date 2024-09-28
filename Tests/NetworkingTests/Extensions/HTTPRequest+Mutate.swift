//
//  HTTPRequest+Mutate.swift
//  Networking
//
//  Created by Adelino Faria on 28/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

extension HTTPRequest {

    func setting(query: [QueryItem]) -> Self {

        switch self {

        case .get(url: let url, query: _, headers: let headers):
            .get(url: url, query: query, headers: headers)
        case .head(url: let url, query: _, headers: let headers):
            .head(url: url, query: query, headers: headers)
        case .post(url: let url, query: _, headers: let headers, body: let body):
            .post(url: url, query: query, headers: headers, body: body)
        case .put(url: let url, query: _, headers: let headers, body: let body):
            .put(url: url, query: query, headers: headers, body: body)
        case .delete(url: let url, query: _, headers: let headers):
            .delete(url: url, query: query, headers: headers)
        case .patch(url: let url, query: _, headers: let headers, body: let body):
            .patch(url: url, query: query, headers: headers, body: body)
        }
    }

    func setting(headers: [HTTPHeader]) -> Self {

        switch self {

        case .get(url: let url, query: let query, headers: _):
            .get(url: url, query: query, headers: headers)
        case .head(url: let url, query: let query, headers: _):
            .head(url: url, query: query, headers: headers)
        case .post(url: let url, query: let query, headers: _, body: let body):
            .post(url: url, query: query, headers: headers, body: body)
        case .put(url: let url, query: let query, headers: _, body: let body):
            .put(url: url, query: query, headers: headers, body: body)
        case .delete(url: let url, query: let query, headers: _):
            .delete(url: url, query: query, headers: headers)
        case .patch(url: let url, query: let query, headers: _, body: let body):
            .patch(url: url, query: query, headers: headers, body: body)
        }
    }

    func setting(body: any NetworkEncodable) -> Self {

        switch self {

        case .get(url: let url, query: let query, headers: let headers):
            .get(url: url, query: query, headers: headers)
        case .head(url: let url, query: let query, headers: let headers):
            .head(url: url, query: query, headers: headers)
        case .post(url: let url, query: let query, headers: let headers, body: _):
            .post(url: url, query: query, headers: headers, body: body)
        case .put(url: let url, query: let query, headers: let headers, body: _):
            .put(url: url, query: query, headers: headers, body: body)
        case .delete(url: let url, query: let query, headers: let headers):
            .delete(url: url, query: query, headers: headers)
        case .patch(url: let url, query: let query, headers: let headers, body: _):
            .patch(url: url, query: query, headers: headers, body: body)
        }
    }
}
