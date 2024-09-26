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

    public func request(_ request: HTTPRequest) async throws -> (Data, URLResponse) {

        let urlRequest = try request.urlRequest(with: self.config)
        let authedURLRequest = try await self.authenticationLogic(urlRequest: urlRequest)
        let (data, urlResponse) = try await self.requestLogic(urlRequest: authedURLRequest)

        return (data, urlResponse)
    }

    public func request<T: NetworkDecodable>(_ request: HTTPRequest) async throws -> T {

        let (data, urlResponse) = try await self.request(request)

        return try await self.decodeLogic(data: data, urlResponse: urlResponse)
    }

    public func request<T: NetworkDecodable, E: NetworkDecodable>(_ request: HTTPRequest) async throws -> Result<T, E> {

        let (data, urlResponse) = try await self.request(request)

        return try await self.decodeLogic(data: data, urlResponse: urlResponse)
    }
}

// TODO: error reporting hook
// TODO: monitoring mechanism - sub package?
// TODO: QoS class?
// TODO: request context?
// TODO: User Agent logic
// TODO: Multipart upload?
