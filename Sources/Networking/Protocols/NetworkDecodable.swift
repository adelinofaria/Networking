//
//  NetworkDecodable.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public protocol NetworkDecodable {

    static func decode(data: Data) async throws(NetworkDecodableError) -> Self
}
