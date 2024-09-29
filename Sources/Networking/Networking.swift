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
    public func request(_ request: HTTPRequest) async throws(NetworkingError) -> (Data, HTTPURLResponse) {

        let urlRequest = try await request.urlRequest(with: self.config)
        let authed: URLRequest

        do {
            authed = try await self.authenticationLogic(urlRequest: urlRequest)
        } catch {
            throw .authentication(error: error)
        }

        let (data, httpURLResponse) = try await self.requestLogic(urlRequest: authed)

        return (data, httpURLResponse)
    }

    // MARK: Return objects straight

    public func request<T: NetworkDecodable>(_ request: HTTPRequest) async throws(NetworkingError) -> T {

        let (data, httpURLResponse) = try await self.request(request)

        do {
            return try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)
        } catch {
            throw .decodable(error: error)
        }
    }

    public func request<T: NetworkDecodable, E: NetworkDecodable>(_ request: HTTPRequest) async throws(NetworkingError) -> Result<T, E> {

        let (data, httpURLResponse) = try await self.request(request)

        do {
            return try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)
        } catch {
            throw .decodable(error: error)
        }
    }

    // MARK: Return objects in HTTPResponse Wrapper object

    public func request<T: NetworkDecodable, E: NetworkDecodable>(_ request: HTTPRequest) async throws(NetworkingError) -> HTTPResponse<T, E> {

        let (data, httpURLResponse) = try await self.request(request)

        do {
            let object: Result<T, E> = try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)

            return .init(result: object,
                         httpStatusCode: httpURLResponse.statusCode,
                         httpHeaders: httpURLResponse.allHeaderFields)
        } catch {
            throw .decodable(error: error)
        }
    }
}

// TODO: background validation or control

// TODO: network service type and cellular
// TODO: QoS class?
