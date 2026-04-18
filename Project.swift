import ProjectDescription

let project = Project(
    name: "ClipVault",
    targets: [
        .target(
            name: "ClipVault",
            destinations: .iOS,
            product: .app,
            bundleId: "com.adii.ClipVault",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "NSPhotoLibraryUsageDescription": "ClipVault needs access to your photos to save videos and reels to your camera roll.",
                "ITSAppUsesNonExemptEncryption": false,
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["App/**", "Views/**", "Models/**", "Services/**", "Utils/**", "Components/**"],
            resources: ["Assets/**"],
            dependencies: [
                // SwiftData is built-in
            ],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "UILaunchImageFile": "LaunchLogo"
            ])
        )
    ]
)
