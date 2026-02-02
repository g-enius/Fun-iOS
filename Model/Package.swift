// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Model",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
    ],
    products: [
        .library(name: "FunModel", targets: ["FunModel"]),
    ],
    dependencies: [
        .package(name: "Toolbox", path: "../Toolbox"),
    ],
    targets: [
        .target(
            name: "FunModel",
            dependencies: [
                .product(name: "FunToolbox", package: "Toolbox"),
            ],
            path: "Sources/Model"
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["FunModel"]
        ),
    ]
)
