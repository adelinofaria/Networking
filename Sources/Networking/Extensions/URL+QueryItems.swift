//
//  URL+QueryItems.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension URL {

    mutating func setQueryString(with queryString: [QueryItem], mergePolicy: Config.MergePolicy) throws(NetworkingURLRequestError) {

        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw .failedToCreateURLComponents
        }

        urlComponents.queryItems?.append(queryString, policy: mergePolicy)

        if let url = urlComponents.url {
            self = url
        } else {
            throw .failedToCreateNewURL
        }
    }
}
