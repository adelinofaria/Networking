//
//  NetworkAuthenticationThrow.swift
//  Networking
//
//  Created by Adelino Faria on 02/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

struct NetworkAuthenticationThrow: NetworkAuthentication {
    func authenticate(urlRequest: URLRequest) async throws(NetworkAuthenticationError) -> URLRequest {
        throw .unknown
    }
}
