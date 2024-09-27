//
//  Networking+Request.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    func requestLogic(urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse) {

        do {
            try Task.checkCancellation()

            let (data, response) = try await self.session.data(for: urlRequest)

            if let httpURLResponse = response as? HTTPURLResponse {

                return (data, httpURLResponse)

            } else {

                throw NetworkingError.invalidResponse(data: data, response: response)
            }

        } catch let error as CancellationError {
            throw error
        } catch {
            throw NetworkingError.urlSessionError(error: error)
        }
    }
}
