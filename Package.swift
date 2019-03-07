// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftLEB",
    products: [
        .library(
            name: "LEB",
            targets: ["LEB"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LEB",
            dependencies: [],
            path: "./Sources/LEB"
        ),
        .testTarget(
            name: "LEBTests",
            dependencies: ["LEB"],
            path: "./Tests/LEBTests"
        ),
    ],
    swiftLanguageVersions: [4]
)
