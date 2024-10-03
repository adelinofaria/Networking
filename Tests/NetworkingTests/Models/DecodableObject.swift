//
//  DecodableObject.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

struct DecodableObject: Sendable, Equatable {

    let a: Bool
    let b: Int
    let c: String

    static var sample: DecodableObject {
        .init(a: true, b: 1, c: "abc")
    }

    static var sampleData: Data {

        [
            "a": true,
            "b": 1,
            "c": "abc",
        ].jsonData() ?? Data()
    }
}

extension DecodableObject: NetworkDecodable {
    static func decode(data: Data) async throws(NetworkDecodableError) -> Self {

        if let dictionary = data.jsonDictionary(),
           let a = dictionary["a"] as? Bool,
           let b = dictionary["b"] as? Int,
           let c = dictionary["c"] as? String {

            return .init(a: a, b: b, c: c)

        } else {

            throw .unknown
        }
    }
}
