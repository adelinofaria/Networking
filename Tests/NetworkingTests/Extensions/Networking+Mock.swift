//
//  Networking+Mock.swift
//  Networking
//
//  Created by Adelino Faria on 03/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation
import Networking

extension Networking {

    static var networkingMock: Networking {

        let urlSessionConfiguration = URLSessionConfiguration.ephemeral

        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        let networking = Networking(urlSession: URLSession(configuration: urlSessionConfiguration))

        return networking
    }
}
