//
//  ConfigTests.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct ConfigTests {

    // MARK: Tests

    @Test("init()")
    func initEmpty() async throws {

        let config = Config()

        #expect(config.queryItemMergePolicy == .overwrite)
        #expect(config.sharedHeaders == [:])
        #expect(config.timeout == 60)
    }

    @Test("init(...)")
    func initWithValues() async throws {

        let config = Config(queryItemMergePolicy: .append, sharedHeaders: ["a": "1"], timeout: 30)

        #expect(config.queryItemMergePolicy == .append)
        #expect(config.sharedHeaders == ["a": "1"])
        #expect(config.timeout == 30)
    }
}
