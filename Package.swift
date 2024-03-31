// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "SSC24-ClimateChange",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "SSC24-ClimateChange",
            targets: ["AppModule"],
            bundleIdentifier: "com.FrancoVelasco.SSC24-ClimateChange",
            teamIdentifier: "84RDPYYLSG",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .landscapeRight
            ],
            capabilities: [
                .camera(purposeString: "See the land you build come to life using the Camera for some AR goodness.")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Storage"),
                .process("Assets/3D Models")
            ]
        )
    ]
)