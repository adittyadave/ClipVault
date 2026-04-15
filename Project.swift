import ProjectDescription

let project = Project(
    name: "ClipVault",
    targets: [
        Target(
            name: "ClipVault",
            platform: .iOS,
            product: .app,
            bundleId: "com.adii.ClipVault",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: .iphone),
            infoPlist: .default,
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
