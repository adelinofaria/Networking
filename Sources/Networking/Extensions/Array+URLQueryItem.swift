//
//  Array+URLQueryItem.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension Array where Element == URLQueryItem {

    mutating func append(_ query: [HTTPQueryItem], policy: Config.MergePolicy) {

        let queryItems = query.map {
            URLQueryItem(name: $0.name, value: $0.value)
        }

        switch policy {
        case .append:

            self.append(contentsOf: queryItems)
        case .overwrite:

            queryItems.forEach { item in
                if let foundIndex = self.firstIndex(where: { $0.name == item.name }) {

                    self[foundIndex].value = item.value

                } else {

                    self.append(item)
                }
            }
        }
    }
}
