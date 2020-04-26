// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "RLottie",
    products: [
        .library(
            name: "RLottie",
            targets: ["RLottie"]),
    ],
    targets: [
        .target(
            name: "RLottie",
            dependencies: ["RLottieCPP"],
            path: "swift"
        ),
        .target(
            name: "RLottieCPP",
            path: ".",
            exclude: [
                "src/vector/pixman/pixman-arm-neon-asm.S",
                "src/CMakeLists.txt",
                "src/binding/CMakeLists.txt",
                "src/binding/c/CMakeLists.txt",
                "src/binding/c/meson.build",
                "src/binding/meson.build",
                "src/lottie/CMakeLists.txt",
                "src/lottie/meson.build",
                "src/meson.build",
                "src/vector/CMakeLists.txt",
                "src/vector/freetype/CMakeLists.txt",
                "src/vector/freetype/meson.build",
                "src/vector/meson.build",
                "src/vector/pixman/CMakeLists.txt",
                "src/vector/pixman/meson.build",
                "src/vector/stb/CMakeLists.txt",
                "src/vector/stb/meson.build",
            ],
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
