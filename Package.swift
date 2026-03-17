// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TreeSitterBicep",
    products: [
        .library(name: "TreeSitterBicep", targets: ["TreeSitterBicep", "TreeSitterBicepParams"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/SwiftTreeSitter", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterBicep",
            dependencies: [],
            path: ".",
            sources: [
                "bicep/src/parser.c",
                "bicep/src/scanner.c",
            ],
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift/TreeSitterBicep",
            cSettings: [.headerSearchPath("bicep/src")]
        ),
        .target(
            name: "TreeSitterBicepParams",
            dependencies: [],
            path: ".",
            sources: [
                "bicep_params/src/parser.c",
                "bicep_params/src/scanner.c",
            ],
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift/TreeSitterBicepParams",
            cSettings: [.headerSearchPath("bicep_params/src")]
        ),
        .testTarget(
            name: "TreeSitterBicepTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterBicep",
                "TreeSitterBicepParams",
            ],
            path: "bindings/swift/TreeSitterBicepTests"
        )
    ],
    cLanguageStandard: .c11
)
