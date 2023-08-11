// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TRTCKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "TRTC",
            targets: ["TXLiteAVSDK_TRTC_SPM", "TXSoundTouch", "TXFFmpeg"]),
        .library(
            name: "TRTCReplayKitExt",
            targets: ["TXLiteAVSDK_ReplayKitExt"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "TXLiteAVSDK_TRTC",
            url: "https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/customer/HelperTest/SPM/TXLiteAVSDK_TRTC.xcframework.zip",
            checksum: "48269bdbfa4b1c374f5016ed142962c848b7036578ad01f09331ff9a94208725"
           ),
        .binaryTarget(
            name: "TXSoundTouch",
            url: "https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/customer/HelperTest/SPM/TXSoundTouch.xcframework.zip",
            checksum: "4870aebc2758afd0f0756db0f4baa478338c45dde6fa45cf2fd7a9b5c5b76ff5"
            ),
        .binaryTarget(
            name: "TXFFmpeg",
            url: "https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/customer/HelperTest/SPM/TXFFmpeg.xcframework.zip",
            checksum: "a9cebf1f50587f9dca69d5ba61c9a2c20a6a80090369056365d2bead660a6e4e"
            ),
        .binaryTarget(
            name: "TXLiteAVSDK_ReplayKitExt",
            url: "https://sdk-liteav-1252463788.cos.ap-hongkong.myqcloud.com/customer/HelperTest/SPM/TXLiteAVSDK_ReplayKitExt.xcframework.zip",
            checksum: "1fa5402691bc4150c73d4535ec040ca54f2859af74af9ef8a80605a9b302284d"
            ),
        .target(
            name: "TXLiteAVSDK_TRTC_SPM",
            dependencies: [
                .target(name: "TXLiteAVSDK_TRTC")
            ],
            sources: ["trtc_swift_package.swift"],
            linkerSettings: [
                .linkedFramework("SystemConfiguration"),
                .linkedFramework("CoreTelephony"),
                .linkedFramework("CoreServices"),
                .linkedFramework("Accelerate"),
                .linkedFramework("ReplayKit"),
                .linkedLibrary("c++")
            ]
        )
    ]
)
