//
//  Networking+Decoding.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

internal extension Networking {

    /// Decoding related logic function, returns straight `T` that conforms to `NetworkDecodable`.
    /// - Parameters:
    ///   - data: `Data` found in HTTP body, to be processed into a `NetworkDecodable`.
    ///   - httpURLResponse: `HTTPURLResponse` object straight from Foundation's `data(for:)`.
    /// - Returns: Expected decoded `T` found in `data`.
    /// - Throws: `NetworkDecodableError`
    func decodeLogic<T: NetworkDecodable>(data: Data, httpURLResponse: HTTPURLResponse) async throws(NetworkDecodableError) -> T {

        if 200...299 ~= httpURLResponse.statusCode {

            let object = try await T.decode(data: data)

            return object

        } else {

            throw .unexpectedStatusCode(data: data, response: httpURLResponse)
        }
    }

    /// Decoding related logic function, returns `Result<T, E>`. `T` and `E` conforms to `NetworkDecodable`.
    /// - Parameters:
    ///   - data: `Data` found in HTTP body, to be processed into a `NetworkDecodable`.
    ///   - httpURLResponse: `HTTPURLResponse` object straight from Foundation's `data(for:)`.
    /// - Returns: Expected decoded `Result<T, E>` found in `data`.
    /// - Throws: `NetworkDecodableError`
    func decodeLogic<T: NetworkDecodable, E: NetworkDecodable>(data: Data, httpURLResponse: HTTPURLResponse) async throws(NetworkDecodableError) -> Result<T, E> {

        if 200...299 ~= httpURLResponse.statusCode {

            let object = try await T.decode(data: data)

            return .success(object)

        } else {

            let object = try await E.decode(data: data)

            return .failure(object)
        }
    }
}
