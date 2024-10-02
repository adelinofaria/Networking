//
//  EncodableObject.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

struct EncodableObject {

    let a: Bool
    let b: Int
    let c: String

    static var sample: EncodableObject {
        .init(a: true, b: 1, c: "123")
    }

    static var sampleData: Data {

        [
            "a": true,
            "b": 1,
            "c": "123",
        ].jsonData() ?? Data()
    }
}

extension EncodableObject: NetworkEncodable {
    var contentType: String? {
        "application/test"
    }

    func encode() async throws(NetworkEncodableError) -> Data {
        ["a": self.a, "b": self.b, "c": self.c].jsonData() ?? Data()
    }
}
