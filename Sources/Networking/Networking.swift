//
//  Networking.swift
//  Networking
//
//  Created by Adelino Faria on 10/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Entrypoint type of `Networking` package.
public final actor Networking {
    
    /// Decoupled authentication logic object.
    public let authentication: NetworkAuthentication?

    /// Config holds default values, shared values and other configurations.
    public let config: Config

    /// Injected `URLSession`, defaults to `.shared`.
    public let session: URLSession
    
    /// Default initializer.
    /// - Parameters:
    ///   - authentication: Object conforming to `NetworkAuthentication`.
    ///   - config: `Config`, defaults to it's empty constructor.
    ///   - urlSession: Injected `URLSession`, defaults to `.shared`.
    public init(authentication: NetworkAuthentication? = nil,
                config: Config = .init(),
                urlSession: URLSession = .shared) {

        self.authentication = authentication
        self.config = config
        self.session = urlSession
    }

    // MARK: Plumbing

    /// Plumbing interface, use this to retrieve exactly what foundation returns.
    /// - Parameter request: `HTTPRequest`
    /// - Returns: `Data` and `HTTPURLResponse` straight from `URLSession`'s `data(for:)`.
    /// - Throws: `NetworkingError`
    public func request<T, E>(_ request: HTTPRequest<T, E>) async throws(NetworkingError) -> (Data, HTTPURLResponse) {

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

    /// `request(:)` variant that returns expected `T` object directly.
    /// - Parameter request: `HTTPRequest` object.
    /// - Returns: Expected `T` model found in HTTP body. Conforms to `NetworkDecodable`.
    /// - Throws: `NetworkingError`
    public func request<T>(_ request: HTTPRequest<T, NoneError>) async throws(NetworkingError) -> T {

        let (data, httpURLResponse) = try await self.request(request)

        do {
            return try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)
        } catch {
            throw .decodable(error: error)
        }
    }

    /// `request(:)` variant that returns `Result<T, E>`. `T` stands for the success model, `E` the error - both are parsed from HTTP body.
    /// - Parameter request: `HTTPRequest` object.
    /// - Returns: `Result<T, E>`, `T` stands for the success model, `E` for the error. Both are parsed from HTTP body and conforms to `NetworkDecodable`.
    /// - Throws: `NetworkingError`
    public func request<T, E>(_ request: HTTPRequest<T, E>) async throws(NetworkingError) -> Result<T, E> {

        let (data, httpURLResponse) = try await self.request(request)

        do {
            return try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)
        } catch {
            throw .decodable(error: error)
        }
    }

    // MARK: Return objects in HTTPResponse Wrapper object

    /// `request(:)` variant that returns `HTTPResponse<T, E>`. `T` stands for the success model, `E` the error - both are parsed from HTTP body.
    /// `HTTPResponse` wraps the `Result<T, E>` plus all scrapped info from a sucessful `HTTPURLResponse`.
    /// - Parameter request: `HTTPRequest` object.
    /// - Returns: `HTTPResponse<T, E>`, `T` stands for the success model, `E` for the error. Both are parsed from HTTP body and conforms to `NetworkDecodable`.
    /// - Throws: `NetworkingError`
    public func request<T, E>(_ request: HTTPRequest<T, E>) async throws(NetworkingError) -> HTTPResponse<T, E> {

        let (data, httpURLResponse) = try await self.request(request)

        do {
            let object: Result<T, E> = try await self.decodeLogic(data: data, httpURLResponse: httpURLResponse)

            return .init(result: object,
                         httpStatusCode: httpURLResponse.statusCode,
                         httpHeaders: httpURLResponse.allHeaderFields as? [String: String])
        } catch {
            throw .decodable(error: error)
        }
    }
}

// TODO: background validation or control

// TODO: network service type and cellular
// TODO: QoS class?
