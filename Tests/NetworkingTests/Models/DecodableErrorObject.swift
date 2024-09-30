//
//  DecodableErrorObject.swift
//  Networking
//
//  Created by Adelino Faria on 30/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

struct DecodableErrorObject: Error, Equatable {

}

extension DecodableErrorObject: NetworkDecodable {
    static func decode(data: Data) async throws(NetworkDecodableError) -> Self {
        .init()
    }
}
