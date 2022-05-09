// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "WolfBase",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
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
