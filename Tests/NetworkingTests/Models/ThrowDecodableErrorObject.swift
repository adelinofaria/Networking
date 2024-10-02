//
//  ThrowDecodableErrorObject.swift
//  Networking
//
//  Created by Adelino Faria on 02/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
@testable import Networking

struct ThrowDecodableObject: NetworkDecodable {
    static func decode(data: Data) async throws(NetworkDecodableError) -> Self {
        throw .unknown
    }
}
