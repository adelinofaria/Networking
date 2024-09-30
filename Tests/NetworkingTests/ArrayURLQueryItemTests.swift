//
//  ArrayURLQueryItemTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct ArrayURLQueryItemTests {

    static let httpQueryItem = HTTPQueryItem(name: "abc", value: "123")

    static let arguments1: [[URLQueryItem]] = [
        [],
        [.init(name: "abc", value: "123")],
        [.init(name: "abcd", value: "1234")],
        [.init(name: "abc", value: "123"), .init(name: "abcd", value: "1234")],
        [.init(name: "abc", value: "123"), .init(name: "abc", value: "123")]
    ]

    static let arguments2: [[HTTPQueryItem]] = [
        [],
        [.init(name: "abc", value: "123")],
        [.init(name: "abcd", value: "1234")],
        [.init(name: "abc", value: "123"), .init(name: "abcd", value: "1234")],
        [.init(name: "abc", value: "123"), .init(name: "abc", value: "123")]
    ]

    @Test("append(:policy: .append)", arguments: arguments1, arguments2)
    func appendQueryWithPolicyAppend(urlQueryItems: [URLQueryItem], queryItems: [HTTPQueryItem]) async throws {

        var mutatingURLQueryItems = urlQueryItems

        mutatingURLQueryItems.append(queryItems, policy: .append)

        #expect(mutatingURLQueryItems.count == urlQueryItems.count + queryItems.count)
    }

    @Test("append(:policy: .overwrite)", arguments: arguments1, arguments2)
    func appendQueryWithPolicyOverwrite(urlQueryItems: [URLQueryItem], queryItems: [HTTPQueryItem]) async throws {

        var mutatingURLQueryItems = urlQueryItems

        mutatingURLQueryItems.append(queryItems, policy: .overwrite)

        var sum = urlQueryItems

        Set(queryItems).forEach { item in
            if !urlQueryItems.contains(where: { $0.name == item.name }) {
                sum.append(.init(name: item.name, value: item.value))
            }
        }

        #expect(mutatingURLQueryItems.count == sum.count)
    }
}
