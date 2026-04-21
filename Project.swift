import ProjectDescription

let project = Project(
    name: "ClipVault",
    targets: [
        .target(
            name: "ClipVault",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.adii.ClipVault",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "NSPhotoLibraryUsageDescription": "ClipVault needs access to your photo library to save videos and photos locally.",
                "NSPhotoLibraryAddUsageDescription": "ClipVault needs permission to save media items to your gallery.",
                "UILaunchStoryboardName": "LaunchScreen",
                "UIBackgroundModes": ["remote-notification"]
            ]),
            sources: ["App/**", "Views/**", "Models/**", "Services/**", "Utils/**", "Components/**"],
            resources: ["Assets/**"],
            dependencies: [
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseCore")
            ]
        )
    ]
)
