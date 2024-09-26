//
//  Networking+Authentication.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//

import Foundation

internal extension Networking {

    func authenticationLogic(urlRequest: URLRequest) async throws -> URLRequest {

        do {
            let authenticatedURLRequest = try await authentication?.authenticate(urlRequest: urlRequest)

            return authenticatedURLRequest ?? urlRequest
        } catch {
            throw NetworkingError.authentication(error: error)
        }
    }
}
