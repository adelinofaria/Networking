//
//  JSONDecodable.swift
//  Networking
//
//  Created by Adelino Faria on 12/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public protocol JSONNetworkDecodable: Decodable, NetworkDecodable {}

public extension JSONNetworkDecodable {

    static var decoder: JSONDecoder {
        JSONDecoder()
    }

    static func decode(data: Data) async throws(NetworkDecodableError) -> Self {

        do {
            let object = try self.decoder.decode(self, from: data)

            return object
        } catch {
            throw .unknown
        }
    }
}
