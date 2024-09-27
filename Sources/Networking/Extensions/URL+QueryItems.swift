//
//  URL+QueryItems.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension URL {

    mutating func setQuery(with query: [QueryItem], mergePolicy: Config.MergePolicy) throws(NetworkingURLRequestError) {

        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw .failedToCreateURLComponents
        }

        urlComponents.queryItems?.append(query, policy: mergePolicy)

        if let url = urlComponents.url {
            self = url
        } else {
            throw .failedToCreateNewURL
        }
    }
}
