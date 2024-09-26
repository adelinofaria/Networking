//
//  Data+Dictionary.swift
//  Networking
//
//  Created by Adelino Faria on 26/09/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension Data {

    func jsonDictionary() -> [String: Any]? {

        let dictionary = try? JSONSerialization.jsonObject(with: self) as? [String: Any]

        return dictionary
    }
}
