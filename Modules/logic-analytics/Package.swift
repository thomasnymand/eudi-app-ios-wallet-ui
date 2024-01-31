// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-analytics",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-analytics",
      targets: ["logic-analytics"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/microsoft/appcenter-sdk-apple.git",
      from: "5.0.4"
    ),
    .package(name: "logic-test", path: "./logic-test")
  ],
  targets: [
    .target(
      name: "logic-analytics",
      dependencies: [
        .product(
          name: "AppCenterAnalytics",
          package: "appcenter-sdk-apple"
        ),
        .product(
          name: "AppCenterCrashes",
          package: "appcenter-sdk-apple"
        )
      ],
      path: "./Sources"
    ),
    .testTarget(
      name: "logic-analytics-test",
      dependencies: [
        "logic-analytics",
        "logic-test"
      ],
      path: "./Tests"
    )
  ]
)
