//
//  HTTPResponse.swift
//  Networking
//
//  Created by Adelino Faria on 27/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// `HTTPResponse` contains all the captured information from a `URLRequest` sent through `URLSession.data(for:)`.
public struct HTTPResponse<T: NetworkDecodable, E: Error & NetworkDecodable>: Sendable {

    /// Result of the data task.
    /// `T` stands for the expected response model captured on reponse's body.
    /// `E` stands for for an error model from a successful connection. (e.g. an API error model from the contract with API)
    /// Both parsed from `HTTPURLResponse`'s body.
    let result: Result<T, E>

    /// Captured `HTTPURLResponse`'s `statusCode`.
    let httpStatusCode: Int

    /// Captured `HTTPURLResponse` HTTP headers.
    let httpHeaders: [String: String]?

    /// Syntatic sugar for the `T` object
    var resultObject: T? {
        if case .success(let object) = self.result {
            return object
        } else {
            return nil
        }
    }

    /// Syntatic sugar for the `E` object
    var resultError: E? {
        if case .failure(let error) = self.result {
            return error
        } else {
            return nil
        }
    }
}
