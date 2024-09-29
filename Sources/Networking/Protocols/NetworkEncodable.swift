//
//  NetworkEncodable.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public protocol NetworkEncodable: Hashable {

    var contentType: String? { get }

    func encode() async throws(NetworkEncodableError) -> Data
}
