//
//  Dictionary+Data.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension Dictionary {

    func jsonData() -> Data? {

        let data = try? JSONSerialization.data(withJSONObject: self)

        return data
    }
}
