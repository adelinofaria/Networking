//
//  None.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Empty object that conforms to `NetworkDecodable` for requests that don't expect body.
public struct None: NetworkDecodable {
    public static func decode(data: Data) async throws(NetworkDecodableError) -> Self {
        .init()
    }
}
