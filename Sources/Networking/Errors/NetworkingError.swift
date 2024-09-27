//
//  NetworkingError.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {
    case unknown
    case invalidURLRequest(error: Error)
    case authentication(error: Error)
    case urlSessionError(error: Error)
    case invalidResponse(data: Data, response: URLResponse)
    case unexpectedStatusCode(data: Data, response: HTTPURLResponse)
}
