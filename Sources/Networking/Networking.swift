//
//  Networking.swift
//  Networking
//
//  Created by Adelino Faria on 10/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public final actor Networking {

    public let authentication: NetworkAuthentication?
    public let config: Config
    public let session: URLSession

    public init(authentication: NetworkAuthentication? = nil,
                config: Config = .init(),
                urlSession: URLSession = .shared) {

        self.authentication = authentication
        self.config = config
        self.session = urlSession
    }

    // MARK: Plumbing

    /// Plumbing interface, use this to retrieve exactly what foundation returns
    /// - Parameter request: HTTPRequest
    /// - Returns: `Data` and `HTTPURLResponse` straight from `URLSession`'s `data(for:)`
    public func request(_ request: HTTPRequest) async throws -> (Data, HTTPURLResponse) {

        let urlRequest = try await request.urlRequest(with: self.config)
        let authedURLRequest = try await self.authenticationLogic(urlRequest: urlRequest)
        let (data, httpURLResponse) = try await self.requestLogic(urlRequest: authedURLRequest)

        return (data, httpURLResponse)
    }

    // MARK: Return objects straight

    public func request<T: NetworkDecodable>(_ request: HTTPRequest) async throws -> T {

        let (data, httpURLResponse) = try await self.request(request)

        return try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)
    }

    public func request<T: NetworkDecodable, E: NetworkDecodable>(_ request: HTTPRequest) async throws -> Result<T, E> {

        let (data, httpURLResponse) = try await self.request(request)

        return try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)
    }

    // MARK: Return objects in NetworkResult Wrapper object

    public func request<T: NetworkDecodable, E: NetworkDecodable>(_ request: HTTPRequest) async throws -> NetworkResult<T, E> {

        let (data, httpURLResponse) = try await self.request(request)

        let object: Result<T, E> = try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)

        return .init(result: object,
                     httpStatusCode: httpURLResponse.statusCode,
                     httpHeaders: httpURLResponse.allHeaderFields)
    }

}

// TODO: NSData encodable
// TODO: error reporting hook
// TODO: monitoring mechanism - sub package?
// TODO: QoS class?
// TODO: request context?
// TODO: User Agent logic
// TODO: Multipart upload?
