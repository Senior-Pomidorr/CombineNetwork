// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineNetwork",
    platforms: [
        .iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "CombineNetwork",
            targets: ["CombineNetwork"]
        ),
    ],
    targets: [
        .target(
            name: "CombineNetwork"
        ),
        .testTarget(
            name: "CombineNetworkTests",
            dependencies: ["CombineNetwork"]
        ),
    ]
)

