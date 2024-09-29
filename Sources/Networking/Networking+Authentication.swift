//
//  Networking+Authentication.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    func authenticationLogic(urlRequest: URLRequest) async throws -> URLRequest {

        do {
            let authenticated = try await self.authentication?.authenticate(urlRequest: urlRequest)

            return authenticated ?? urlRequest
        } catch {
            throw NetworkingError.authentication(error: error)
        }
    }
}
