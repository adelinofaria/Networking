//
//  URL+QueryItems.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension URL {

    mutating func setQueryString(with queryString: [String: String], mergePolicy: Config.MergePolicy) throws(NetworkingURLRequestError) {

        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw .failedToCreateURLComponents
        }

        let queryItems = queryString.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        urlComponents.queryItems?.append(queryItems, policy: mergePolicy)

        if let url = urlComponents.url {
            self = url
        } else {
            throw .failedToCreateNewURL
        }
    }
}
