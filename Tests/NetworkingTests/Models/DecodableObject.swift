//
//  DecodableObject.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//

import Foundation
import Networking

struct DecodableObject: JSONNetworkDecodable {

    let a: Bool
    let b: Int
    let c: String

    static func sampleObjectData() -> Data {

        let jsonData = try? [
            "a": true,
            "b": 1,
            "c": "123",
        ].jsonData()

        return jsonData ?? Data()
    }
}

extension Dictionary {

    func jsonData() throws -> Data {

        let data = try JSONSerialization.data(withJSONObject: self)

        return data
    }
}
