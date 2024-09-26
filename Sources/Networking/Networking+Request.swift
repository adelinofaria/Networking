//
//  Networking+Request.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    func requestLogic(urlRequest: URLRequest) async throws -> (Data, URLResponse) {

        do {
            try Task.checkCancellation()

            let result = try await self.session.data(for: urlRequest)

            return result
        } catch let error as CancellationError {
            throw error
        } catch {
            throw NetworkingError.urlSessionError(error: error)
        }
    }
}
