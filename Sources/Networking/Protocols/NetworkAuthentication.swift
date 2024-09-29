//
//  NetworkAuthentication.swift
//  Networking
//
//  Created by Adelino Faria on 11/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public protocol NetworkAuthentication {
    func authenticate(urlRequest: URLRequest) async throws(NetworkAuthenticationError) -> URLRequest
}
