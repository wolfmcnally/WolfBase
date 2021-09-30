// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "WolfBase",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "WolfBase",
            targets: ["WolfBase"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WolfBase",
            dependencies: []),
        .testTarget(
            name: "WolfBaseTests",
            dependencies: ["WolfBase"]),
    ]
)
