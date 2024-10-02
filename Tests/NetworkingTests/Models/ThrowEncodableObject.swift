//
//  ThrowEncodableObject.swift
//  Networking
//
//  Created by Adelino Faria on 02/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
@testable import Networking

struct ThrowEncodableObject: NetworkEncodable {

    var contentType: String? {
        nil
    }

    func encode() async throws(NetworkEncodableError) -> Data {
        throw .unknown
    }
}
