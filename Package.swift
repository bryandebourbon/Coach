// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Coach",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Coach",
            targets: ["Coach"]
        ),
    ],
    targets: [
        .target(
            name: "Coach",
            dependencies: []
        ),
        .testTarget(
            name: "CoachTests",
            dependencies: ["Coach"]
        ),
    ]
)