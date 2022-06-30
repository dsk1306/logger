// swift-tools-version: 5.5
import PackageDescription

let package = Package(
  name: "Logger",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "Logger",
      targets: ["Logger"]
    )
  ],
  dependencies: [
    .package(
        name: "Bugsnag",
        url: "https://github.com/bugsnag/bugsnag-cocoa",
        .upToNextMajor(from: "6.19.0")
    )
  ],
  targets: [
    .target(
      name: "Logger",
      dependencies: ["Bugsnag"],
      path: "Sources"
    ),
    .testTarget(
      name: "LoggerTests",
      dependencies: ["Logger"],
      path: "Tests"
    )
  ]
)
