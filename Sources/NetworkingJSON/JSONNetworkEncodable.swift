//
//  JSONNetworkEncodable.swift
//  NetworkingJSON
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

public protocol JSONNetworkEncodable: Encodable, NetworkEncodable {}

public extension JSONNetworkEncodable {

    static var encoder: JSONEncoder {
        JSONEncoder()
    }

    var contentType: String? {
        return "application/json"
    }

    func encode() async throws(NetworkEncodableError) -> Data {

        do {
            let data = try Self.encoder.encode(self)

            return data
        } catch {
            throw .unknown
        }
    }
}
