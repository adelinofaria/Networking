//
//  HTTPRequest+Mutate.swift
//  Networking
//
//  Created by Adelino Faria on 28/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
@testable import Networking

extension HTTPRequest {

    func setting(query: [HTTPQueryItem]) -> Self {

        switch self.method {

        case .get:
                .get(url: self.url, query: query, headers: self.headers)
        case .head:
                .head(url: self.url, query: query, headers: self.headers)
        case .post:
                .post(url: self.url, query: query, headers: self.headers, body: self.body)
        case .put:
                .put(url: self.url, query: query, headers: self.headers, body: self.body)
        case .delete:
                .delete(url: self.url, query: query, headers: self.headers)
        case .patch:
                .patch(url: self.url, query: query, headers: self.headers, body: self.body)
        }
    }

    func setting(headers: [HTTPHeader]) -> Self {

        switch self.method {

        case .get:
                .get(url: self.url, query: self.query, headers: headers)
        case .head:
                .head(url: self.url, query: self.query, headers: headers)
        case .post:
                .post(url: self.url, query: self.query, headers: headers, body: self.body)
        case .put:
                .put(url: self.url, query: self.query, headers: headers, body: self.body)
        case .delete:
                .delete(url: self.url, query: self.query, headers: headers)
        case .patch:
                .patch(url: self.url, query: self.query, headers: headers, body: self.body)
        }
    }

    func setting(body: any NetworkEncodable) -> Self {

        switch self.method {

        case .get:
                .get(url: self.url, query: self.query, headers: self.headers)
        case .head:
                .head(url: self.url, query: self.query, headers: self.headers)
        case .post:
                .post(url: self.url, query: self.query, headers: self.headers, body: body)
        case .put:
                .put(url: self.url, query: self.query, headers: self.headers, body: body)
        case .delete:
                .delete(url: self.url, query: self.query, headers: self.headers)
        case .patch:
                .patch(url: self.url, query: self.query, headers: self.headers, body: body)
        }
    }
}
