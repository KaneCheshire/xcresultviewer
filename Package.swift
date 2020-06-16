// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "XCResultViewer"

let package = Package(
    name: name,
	platforms: [.macOS(.v10_10)],
    products: [.library(name: name, targets: [name])],
	targets: [.target(name: name, path: "xcresult")],
	swiftLanguageVersions: [.v5]
)
