// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ACInteractor",
    products: [
        .library(name: "ACInteractor", targets: ["ACInteractor"])
    ],
    targets: [
        .target(name: "ACInteractor"),
        .testTarget(name: "ACInteractorTests", dependencies: ["ACInteractor"])
    ]
)
