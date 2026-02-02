// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
    ],
    products: [
        .library(name: "FunCore", targets: ["FunCore"]),
    ],
    targets: [
        .target(
            name: "FunCore",
            path: "Sources/Core"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["FunCore"]
        ),
    ]
)
