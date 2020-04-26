// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "RLottie++",
    products: [
        .library(
            name: "RLottie++",
            targets: ["RLottie++"]),
    ],
    targets: [
        .target(
            name: "RLottie++",
            path: ".",
            exclude: ["src/vector/pixman/pixman-arm-neon-asm.S"],
            sources: ["src"],
            publicHeadersPath: "inc",
            cxxSettings: [
                .headerSearchPath("inc_cpp"),
                .headerSearchPath("vs2019"),
                .headerSearchPath("src/vector"),
                .headerSearchPath("src/vector/freetype"),
            ]
        ),
    ],
    cxxLanguageStandard: .cxx14
)
