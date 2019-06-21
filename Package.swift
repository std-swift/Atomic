// swift-tools-version:5.0
//
//  Package.swift
//  Atomic
//

import PackageDescription

let package = Package(
	name: "Atomic",
	platforms: [
		.macOS(.v10_12)
	],
	products: [
		.library(
			name: "Atomic",
			targets: ["Atomic"]),
	],
	dependencies: [
		.package(url: "https://github.com/std-swift/Time.git",
		         from: "1.0.0"),
	],
	targets: [
		.target(
			name: "Atomic",
			dependencies: ["Time"]),
		.testTarget(
			name: "AtomicTests",
			dependencies: ["Atomic"]),
	]
)
