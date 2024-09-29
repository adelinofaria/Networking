//
//  NetworkDecodableError.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public enum NetworkDecodableError: Error {
    case unknown
    case generic(error: Error)
    case unexpectedStatusCode(data: Data, response: HTTPURLResponse)
}
