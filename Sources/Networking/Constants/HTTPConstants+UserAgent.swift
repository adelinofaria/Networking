//
//  HTTPConstants+UserAgent.swift
//  Networking
//
//  Created by Adelino Faria on 28/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)
import UIKit
#elseif os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#else
import Foundation
#endif

extension HTTPConstants {

    @MainActor
    static func userAgentLogic() -> String {

        // User-Agent implementation based on - https://www.rfc-editor.org/rfc/rfc9110.html#name-user-agent
        // Example: "App/1.0.0 (Macintosh; MacOS/14.6.1; Scale/1.00)"
        // Example: "App/1.0.0 (iPhone; iOS/18.0.0; Scale/3.00)"
        // Example: "App/1.0.0 (iPad; iPadOS/18.0.0; Scale/2.00)"
        // Example: "App/1.0.0 (Apple Watch; watchOS/11.0.0; Scale/2.00)"

        let executableName = ProcessInfo.processInfo.processName
        let executableVersion = Bundle.main.infoDictionary?[Constants.bundleShortVersion] as? String

        let deviceModel: String?
        let osName: String?
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let screenScale: CGFloat?

        #if os(iOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)

            deviceModel = UIDevice.current.model
            osName = UIDevice.current.systemName
            screenScale = UIScreen.main.scale

        #elseif os(macOS)

            deviceModel = HTTPConstants.userAgentDeviceMacOS
            osName = HTTPConstants.userAgentMacOS
            screenScale = NSScreen.main?.backingScaleFactor

        #elseif os(watchOS)

            deviceModel = WKInterfaceDevice.current().model
            osName = WKInterfaceDevice.current().systemName
            screenScale = WKInterfaceDevice.current().screenScale

        #endif

        let userAgent = Self.userAgent(executableName: executableName,
                                       executableVersion: executableVersion,
                                       deviceModel: deviceModel,
                                       osName: osName,
                                       osVersion: osVersion,
                                       screenScale: screenScale)

        return userAgent
    }

    @MainActor
    static func userAgent(executableName: String,
                          executableVersion: String?,
                          deviceModel: String?,
                          osName: String?,
                          osVersion: OperatingSystemVersion,
                          screenScale: CGFloat?) -> String {

        let productIdentifier: String

        if let executableVersion {

            productIdentifier = "\(executableName)/\(executableVersion)"

        } else {

            productIdentifier = executableName
        }

        var productComments: [String] = []

        if let deviceModel {

            productComments.append(deviceModel)
        }

        if let osName {

            productComments.append(osName + "/" + osVersion.versionString)
        }

        if let screenScale {

            productComments.append(HTTPConstants.userAgentScale + "/" + String(format: "%0.2f", screenScale))
        }

        let productComment = productComments.joined(separator: "; ")

        let userAgentString: String

        if productComment.count > 0 {
            userAgentString = productIdentifier + " (" + productComment + ")"
        } else {
            userAgentString = productIdentifier
        }

        return userAgentString
    }
}

extension OperatingSystemVersion {

    var versionString: String {
        "\(self.majorVersion).\(self.minorVersion).\(self.patchVersion)"
    }
}
