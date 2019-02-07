// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ACInteractor",
    products: [
        .library(
            name: "ACInteractor",
            targets: ["ACInteractor"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "ACInteractor",
            dependencies: []),
        .testTarget(
            name: "ACInteractorTests",
            dependencies: ["ACInteractor"]),
        ]
)
