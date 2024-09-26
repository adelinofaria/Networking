//
//  Config.swift
//  Networking
//
//  Created by Adelino Faria on 24/09/2024.
//

/*
 Configure timeout
 Configure sucess response range 200...299 default
 Configure Accept, Content-Type, User-Agent

 */

public struct Config {

    public enum MergePolicy {
        case append
        case overwrite
    }

    /// Although duplication of query items isn't a prefered practice, some APIs do use to some extent. To allow such behaviour set his property to `.append`.
    public let queryItemMergePolicy: MergePolicy

    public init(queryItemMergePolicy: MergePolicy = .overwrite) {
        self.queryItemMergePolicy = queryItemMergePolicy
    }
}
