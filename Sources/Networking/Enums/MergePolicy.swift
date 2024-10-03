//
//  MergePolicy.swift
//  Networking
//
//  Created by Adelino Faria on 29/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

/// Available strategies to be used when resolving merges of `URL`'s query string keys and values.
public enum MergePolicy: Sendable {
    case append
    case overwrite
}
