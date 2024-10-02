//
//  NetworkCodable.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `NetworkCodable` is a type alias for the `NetworkDecodable` and `NetworkEncodable` protocols.
typealias NetworkCodable = NetworkDecodable & NetworkEncodable
