//
//  Networking+Request.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    /// Core networking logic function.
    /// - Parameter request: Raw `URLRequest`ready to be sent over network.
    /// - Returns: Pair `Data` and `HTTURLResponse` received from Foundation's `data(for:)`, ready for further response processing.
    /// - Throws: `NetworkingError`
    func requestLogic(urlRequest: URLRequest) async throws(NetworkingError) -> (Data, HTTPURLResponse) {

        let (data, response): (Data, URLResponse)

        do {
            try Task.checkCancellation()

            (data, response) = try await self.session.data(for: urlRequest)

        } catch let error as CancellationError {
            throw .canceled(error: error)
        } catch {
            throw .urlSessionError(error: error)
        }

        if let httpURLResponse = response as? HTTPURLResponse {

            return (data, httpURLResponse)

        } else {

            throw .invalidResponse(data: data, response: response)
        }
    }
}
