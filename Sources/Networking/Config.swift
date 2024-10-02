//
//  Config.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `Config` holds default values, shared values and configured policies for internal use.
public struct Config {

    /// Although duplication of query items isn't a prefered practice, some APIs do use to some extent. To allow such behaviour set his property to `.append`.
    public let queryItemMergePolicy: MergePolicy

    /// HTTP Headers to be injected in all requests.
    public let sharedHeaders: [String: String]

    /// Default value for `URLRequest` timeout mechanic.
    public let timeout: TimeInterval
    
    /// Default initializer
    /// - Parameters:
    ///   - queryItemMergePolicy: `MergePolicy` to be configured, defaults to `.overwrite`.
    ///   - sharedHeaders: HTTP Headers to be injected in all requests.
    ///   - timeout: Default value for `URLRequest` timeout mechanic.
    public init(queryItemMergePolicy: MergePolicy = .overwrite,
                sharedHeaders: [String: String] = [:],
                timeout: TimeInterval = Constants.timeoutDefault) {
        self.queryItemMergePolicy = queryItemMergePolicy
        self.sharedHeaders = sharedHeaders
        self.timeout = timeout
    }
}
