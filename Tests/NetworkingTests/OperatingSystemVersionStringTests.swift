//
//  OperatingSystemVersionStringTests.swift
//  Networking
//
//  Created by Adelino Faria on 01/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

@Suite
struct OperatingSystemVersionStringTests {

    // MARK: Tests

    @Test("var versionString")
    func versionString() async throws {

        let osVersion = OperatingSystemVersion(majorVersion: 1, minorVersion: 2, patchVersion: 3)

        #expect(osVersion.versionString == "1.2.3")
    }
}
