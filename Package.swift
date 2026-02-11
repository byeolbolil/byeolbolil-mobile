// swift-tools-version: 6.1
// This is a Skip (https://skip.tools) package.
import PackageDescription

let package = Package(
    name: "byeolbolil-mobile",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ByeolbolilMobile", type: .dynamic, targets: ["ByeolbolilMobile"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.7.1"),
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "ByeolbolilMobile", dependencies: [
            .product(name: "SkipFuseUI", package: "skip-fuse-ui")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
