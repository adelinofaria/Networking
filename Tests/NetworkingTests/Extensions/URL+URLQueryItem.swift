//
//  URL+URLQueryItem.swift
//  Networking
//
//  Created by Adelino Faria on 01/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
@testable import Networking

extension URL {

    var queryItems: [URLQueryItem] {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems ?? []
    }

    func queryItems(with queryItems: [HTTPQueryItem]) -> [URLQueryItem] {

        let urlQueryItems = self.queryItems
        var sum = urlQueryItems

        Set(queryItems).forEach { item in
            if !urlQueryItems.contains(where: { $0.name == item.name }) {
                sum.append(.init(name: item.name, value: item.value))
            }
        }

        return sum
    }
}
