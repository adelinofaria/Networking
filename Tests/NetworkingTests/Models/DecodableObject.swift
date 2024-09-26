//
//  DecodableObject.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

struct DecodableObject: JSONNetworkDecodable {

    let a: Bool
    let b: Int
    let c: String

    static func sampleObjectData() -> Data {

        [
            "a": true,
            "b": 1,
            "c": "123",
        ].jsonData()
    }
}
