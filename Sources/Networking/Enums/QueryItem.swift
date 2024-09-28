//
//  QueryItem.swift
//  Networking
//
//  Created by Adelino Faria on 27/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Struct to store queryString's keys and values.
/// We store this in a struct as opposed to dictionaries to maintain order and uniqueness of it's keys and values
public struct QueryItem: Equatable {
    let name: String
    let value: String
}
