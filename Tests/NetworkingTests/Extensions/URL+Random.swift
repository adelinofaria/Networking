//
//  URL+Random.swift
//  Networking
//
//  Created by Adelino Faria on 30/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Testing

extension URL {

    static func random(queryString: [String: String]? = nil) throws -> URL {
        let uuid = UUID().uuidString
        let urlString: String

        if let queryString, queryString.count > 0 {

            let joined = queryString.map { $0.key + "=" + $0.value }.joined(separator: "&")

            urlString = "https://domain.toplevel/" + uuid + "?" + joined

        } else {

            urlString = "https://domain.toplevel/" + uuid
        }

        return try #require(URL(string: urlString))
    }
}
