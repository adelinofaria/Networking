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

    static var sampleData: Data {

        [
            "a": true,
            "b": 1,
            "c": "abc",
        ].jsonData() ?? Data()
    }
}
