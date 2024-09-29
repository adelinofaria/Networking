//
//  Config.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public struct Config {

    /// Although duplication of query items isn't a prefered practice, some APIs do use to some extent. To allow such behaviour set his property to `.append`.
    public let queryItemMergePolicy: MergePolicy
    public let sharedHeaders: [String: String]
    public let timeout: TimeInterval

    public init(queryItemMergePolicy: MergePolicy = .overwrite,
                sharedHeaders: [String: String] = [:],
                timeout: TimeInterval = Constants.timeoutDefault) {
        self.queryItemMergePolicy = queryItemMergePolicy
        self.sharedHeaders = sharedHeaders
        self.timeout = timeout
    }
}
