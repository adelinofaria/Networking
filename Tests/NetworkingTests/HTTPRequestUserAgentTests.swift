//
//  HTTPRequestUserAgentTests.swift
//  Networking
//
//  Created by Adelino Faria on 28/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing
@testable import Networking

#if os(iOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)
import UIKit
#elseif os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#endif

@Suite
struct HTTPRequestUserAgentTests {

    // MARK: Tests

    @Test
    func userAgentForCurrentEnvironment() async throws {

        let executableName = ProcessInfo.processInfo.processName

        let productIdentifier: String

        if let executableVersion = Bundle.main.infoDictionary?[Constants.bundleShortVersion] as? String {
            productIdentifier = "\(executableName)/\(executableVersion)"
        } else {
            productIdentifier = "\(executableName)"
        }

        let osVersion = ProcessInfo.processInfo.operatingSystemVersion.versionString

        let userAgent = await HTTPConstants.userAgent

        #if os(iOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)

            let deviceModel = await UIDevice.current.model
            let osName = await UIDevice.current.systemName
            let screenScale = await UIScreen.main.scale

            let expectation = "\(productIdentifier) (\(deviceModel); \(osName)/\(osVersion); Scale/\(String(format: "%0.2f", screenScale)))"

            #expect(userAgent == expectation)

        #elseif os(macOS)

            let screenScale = try #require(NSScreen.main?.backingScaleFactor)

            let expectation = "\(productIdentifier) (Macintosh; MacOS/\(osVersion); Scale/\(String(format: "%0.2f", screenScale)))"

            #expect(userAgent == expectation)

        #elseif os(watchOS)

            let deviceModel = WKInterfaceDevice.current().model
            let osName = WKInterfaceDevice.current().systemName
            let screenScale = WKInterfaceDevice.current().screenScale

            let expectation = "\(productIdentifier) (\(deviceModel); \(osName)/\(osVersion); Scale/\(String(format: "%0.2f", screenScale)))"

            #expect(userAgent == expectation)

        #else
            Issue.record("Unsupported OS")
        #endif
    }

    @Test
    func userAgentFullFields() async throws {

        let userAgent = await HTTPConstants.userAgent(executableName: "executable",
                                                      executableVersion: "1.2.3",
                                                      deviceModel: "Device",
                                                      osName: "OS",
                                                      osVersion: .init(majorVersion: 1,
                                                                       minorVersion: 0,
                                                                       patchVersion: 0),
                                                      screenScale: 5.0)
        #expect(userAgent == "executable/1.2.3 (Device; OS/1.0.0; Scale/5.00)")
    }

    @Test
    func userAgentOptionalExceptions() async throws {

        let userAgent = await HTTPConstants.userAgent(executableName: "executable",
                                                      executableVersion: nil,
                                                      deviceModel: nil,
                                                      osName: nil,
                                                      osVersion: .init(majorVersion: 1,
                                                                       minorVersion: 0,
                                                                       patchVersion: 0),
                                                      screenScale: nil)
        #expect(userAgent == "executable")
    }
}
