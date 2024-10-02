//
//  OperatingSystemVersion+String.swift
//  Networking
//
//  Created by Adelino Faria on 01/10/2024.
//  Copyright © 2024 Adelino Faria. All rights reserved.
//

import Foundation

extension OperatingSystemVersion {

    /// Version string following semantic versioning format.
    var versionString: String {
        "\(self.majorVersion).\(self.minorVersion).\(self.patchVersion)"
    }
}
