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
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WolfBase",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
        .testTarget(
            name: "WolfBaseTests",
            dependencies: ["WolfBase"]),
    ]
)
