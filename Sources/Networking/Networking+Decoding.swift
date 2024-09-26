//
//  Networking+Decoding.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//

import Foundation

internal extension Networking {

    func decodeLogic<T: NetworkDecodable>(data: Data, urlResponse: URLResponse) async throws -> T {

        if let httpUrlResponse = urlResponse as? HTTPURLResponse,
           200...299 ~= httpUrlResponse.statusCode {

            let object = try await T.decode(data: data)

            return object

        } else {
            //FIXME: not http url response?
            throw NetworkingError.invalidResponse(data: data, response: urlResponse)
        }
    }

    func decodeLogic<T: NetworkDecodable, E: NetworkDecodable>(data: Data, urlResponse: URLResponse) async throws -> Result<T, E> {

        if let httpUrlResponse = urlResponse as? HTTPURLResponse,
           200...299 ~= httpUrlResponse.statusCode {

            let object = try await T.decode(data: data)

            return .success(object)

        } else if let _ = urlResponse as? HTTPURLResponse {

            //FIXME: non ok status code, we parse an error
            let object = try await E.decode(data: data)

            return .failure(object)

        } else {
            //FIXME: not http url response?
            throw NetworkingError.invalidResponse(data: data, response: urlResponse)
        }
    }
}
