// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "IPTVKit",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .macOS(.v12),
    ],
    products: [
        .library(name: "IPTVKit", targets: ["IPTVKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna", .upToNextMajor(from: "5.2.7"))
    ],
    targets: [
        .target(name: "IPTVKit", dependencies: ["Kanna"], path: "Sources"),
    ]
)
