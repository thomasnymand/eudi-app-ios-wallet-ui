// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "logic-navigation",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "logic-navigation",
      targets: ["logic-navigation"]
    )
  ],
  dependencies: [
    .package(name: "feature-startup", path: "./feature-startup")
  ],
  targets: [
    .target(
      name: "logic-navigation",
      dependencies: [
        "feature-startup"
      ],
      path: "./Sources"
    )
  ]
)