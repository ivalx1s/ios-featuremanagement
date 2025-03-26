// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ios-featuremanagement",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ReluxFeatureManagement",
            targets: ["ReluxFeatureManagement"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ivalx1s/darwin-keychainaccess.git", .upToNextMajor(from: "4.2.3")),
        .package(url: "https://github.com/ivalx1s/darwin-relux.git", .upToNextMajor(from: "8.0.1")),
        .package(url: "https://github.com/ivalx1s/swift-stdlibplus.git", .upToNextMajor(from: "3.1.0")),
        .package(url: "https://github.com/ivalx1s/darwin-foundationplus.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "ReluxFeatureManagement",
            dependencies: [
                .product(name: "Relux", package: "darwin-relux"),
                .product(name: "KeychainAccess", package: "darwin-keychainaccess"),
                .product(name: "SwiftPlus", package: "swift-stdlibplus"),
                .product(name: "FoundationPlus", package: "darwin-foundationplus"),
            ],
            path: "Sources"
        )
    ]
)

