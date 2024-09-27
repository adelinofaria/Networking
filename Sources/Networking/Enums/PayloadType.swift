//
//  PayloadType.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Struct to store queryString's keys and values.
/// We store this in a struct as opposed to dictionaries to maintain order and uniqueness of it's keys and values
public struct QueryItem: Equatable {
    let name: String
    let value: String
}

/// Struct to store HTTP headers key and values.
public struct HTTPHeader: Equatable {
    let name: String
    let value: String
}
