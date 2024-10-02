//
//  Networking+Authentication.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    /// Authentication related logic function.
    /// - Parameter request: Raw `URLRequest` to be authenticated just before networking.
    /// - Returns: Processed `URLRequest` ready for networking.
    /// - Throws: `NetworkAuthenticationError`
    func authenticationLogic(urlRequest: URLRequest) async throws(NetworkAuthenticationError) -> URLRequest {

        let authenticated = try await self.authentication?.authenticate(urlRequest: urlRequest)

        return authenticated ?? urlRequest
    }
}
