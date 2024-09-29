//
//  NetworkingURLRequestError.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

enum NetworkingURLRequestError: Error {
    case unknown
    case failedToCreateURLComponents
    case failedToCreateNewURL
    case invalidURL(Error)
}
