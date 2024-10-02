//
//  NetworkAuthenticationError.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Expected thrown errors coming the usage of the `NetworkAuthentication` protocol.
public enum NetworkAuthenticationError: Error {

    /// Unexpected and unsupported error.
    case unknown

    /// General purpose error case, used when there's no especialized alternative.
    case generic(error: Error)
}
