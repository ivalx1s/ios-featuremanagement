// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ios-featuremanagement",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FeatureManagementModule",
            targets: ["FeatureManagementModule"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ivalx1s/darwin-keychainaccess.git", .upToNextMajor(from: "4.2.3")),
        .package(url: "https://github.com/ivalx1s/darwin-relux.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/ivalx1s/swift-stdlibplus.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/ivalx1s/darwin-foundationplus.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "FeatureManagementModule",
            dependencies: [
                .product(name: "Relux", package: "darwin-relux"),
                .product(name: "KeychainAccess", package: "darwin-keychainaccess"),
                .product(name: "SwiftPlus", package: "swift-stdlibplus"),
                .product(name: "FoundationPlus", package: "darwin-foundationplus"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "FeatureManagementModuleTests",
            dependencies: ["FeatureManagementModule"],
            path: "Tests"
        ),
    ]
)

