// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DongdongCompatibility",
    platforms: [.iOS("26.0")],
    products: [.library(name: "CompatibilityCore", targets: ["CompatibilityCore"])],
    targets: [
        .target(name: "CompatibilityCore"),
        .testTarget(name: "CompatibilityCoreTests", dependencies: ["CompatibilityCore"])
    ]
)
