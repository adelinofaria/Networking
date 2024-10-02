//
//  HTTPConstants.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Wrapper type that holds all HTTP protocol constants
enum HTTPConstants {

    // MARK: Header Keys

    static let acceptHeaderKey = "Accept"
    static let contentLengthHeaderKey = "Content-Length"
    static let contentTypeHeaderKey = "Content-Type"
    static let userAgentHeaderKey = "User-Agent"

    // MARK: Header Values

    static let userAgentDeviceMacOS = "Macintosh"
    static let userAgentMacOS = "MacOS"
    static let userAgentScale = "Scale"

    @MainActor
    static let userAgent = {
        Self.userAgentLogic()
    }()
}
