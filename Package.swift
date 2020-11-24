// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftLogging",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftLogging",
            targets: ["SwiftLogging"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Esri/SwiftIO.git", from: "0.5.2"),
        .package(url: "https://github.com/Esri/SwiftUtilities.git", from: "0.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftLogging",
            dependencies: ["SwiftIO","SwiftUtilities"]),
        .testTarget(
            name: "SwiftLoggingTests",
            dependencies: ["SwiftLogging"]),
    ]
)
