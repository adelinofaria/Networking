// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "NetworkingJSON", targets: ["NetworkingJSON"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.

        // MARK: Networking

        .target(
            name: "Networking",
            path: "Sources/Networking",
            resources: [.process("Resources/PrivacyInfo.xcprivacy")],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS, .macCatalyst, .tvOS])),
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
              ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            path: "Tests/NetworkingTests"
        ),

        // MARK: NetworkingJSON

        .target(
            name: "NetworkingJSON",
            dependencies: ["Networking"],
            path: "Sources/NetworkingJSON",
            resources: [.process("Resources/PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "NetworkingJSONTests",
            dependencies: ["NetworkingJSON"],
            path: "Tests/NetworkingJSONTests"
        ),
    ]
)
