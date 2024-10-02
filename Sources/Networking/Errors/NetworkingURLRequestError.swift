//
//  NetworkingURLRequestError.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public enum NetworkingURLRequestError: Error {

    /// Unexpected and unsupported error.
    case unknown

    ///  Couldn't create `URLComponents` to modify the `URL`.
    case failedToCreateURLComponents

    ///  Couldn't create `URL`from modifying `URLComponents`.
    case failedToCreateURLFromURLComponents
}
