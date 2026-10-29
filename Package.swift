// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TrisMotionKit",
    platforms: [.iOS(.v17)],
    products: [.library(name: "TrisMotionKit", targets: ["TrisMotionKit"])],
    targets: [
        .target(name: "TrisMotionKit"),
        .testTarget(name: "TrisMotionKitTests", dependencies: ["TrisMotionKit"])
    ]
)
