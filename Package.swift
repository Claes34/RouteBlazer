// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RouteBlazer",
    platforms: [
        .iOS(.v16),
    ],
    products: [
      .library(
        name: "RouteBlazer",
        targets: ["RouteBlazer"]
      ),
    ],
    targets: [
        .target(
            name: "RouteBlazer"
        ),
        .testTarget(
            name: "RouteBlazerTests",
            dependencies: ["RouteBlazer"]
        ),
    ]
)
