//
//  Array+URLQueryItem.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension Array where Element == URLQueryItem {

    mutating func append(_ queryItems: [URLQueryItem], policy: Config.MergePolicy) {

        switch policy {
        case .append:
            self.append(contentsOf: queryItems)
        case .overwrite:
            self = queryItems
        }
    }
}
