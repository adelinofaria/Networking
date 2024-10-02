//
//  NetworkEncodableError.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Expected thrown errors coming the usage of the `NetworkEncodable` protocol.
public enum NetworkEncodableError: Error {

    /// Unexpected and unsupported error.
    case unknown

    /// General purpose error case, used when there's no especialized alternative.
    case generic(error: Error)
}
