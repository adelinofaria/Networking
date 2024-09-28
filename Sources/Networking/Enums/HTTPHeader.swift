//
//  HTTPHeader.swift
//  Networking
//
//  Created by Adelino Faria on 27/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Struct to store HTTP headers key and values.
public struct HTTPHeader: Equatable {
    let name: String
    let value: String
}
