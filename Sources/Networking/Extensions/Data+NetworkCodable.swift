//
//  Data+NetworkCodable.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Conformance of `Data` to `NetworkCodable`. Enabling the use of straight `Data` for request/reponse.
extension Data: NetworkCodable {

    public static func decode(data: Data) async throws(NetworkDecodableError) -> Self {
        data
    }

    public var contentType: String? {
        nil
    }

    public func encode() async throws(NetworkEncodableError) -> Data {
        self
    }
}
