//
//  NoError.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

struct NoError: NetworkDecodable, Error {
    static func decode(data: Data) async throws(NetworkDecodableError) -> Self {
        return .init()
    }
}
