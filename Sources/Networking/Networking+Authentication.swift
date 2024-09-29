//
//  Networking+Authentication.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    func authenticationLogic(urlRequest: URLRequest) async throws(NetworkAuthenticationError) -> URLRequest {

        let authenticated = try await self.authentication?.authenticate(urlRequest: urlRequest)

        return authenticated ?? urlRequest
    }
}
