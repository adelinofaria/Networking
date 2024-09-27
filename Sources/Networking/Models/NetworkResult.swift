//
//  NetworkResult.swift
//  Networking
//
//  Created by Adelino Faria on 27/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public struct NetworkResult<T: NetworkDecodable, E: Error & NetworkDecodable> {
    let result: Result<T, E>
    let httpStatusCode: Int
    let httpHeaders: [AnyHashable: Any]

    var resultObject: T? {
        if case .success(let object) = self.result {
            return object
        } else {
            return nil
        }
    }

    var resultError: E? {
        if case .failure(let error) = self.result {
            return error
        } else {
            return nil
        }
    }
}
