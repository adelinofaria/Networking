//
//  PayloadType.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

public enum PayloadType {
    case queryString([String: String])
    case headers([String: String])
    case body(Data)
//    case body(NetworkingEncodable)
}
