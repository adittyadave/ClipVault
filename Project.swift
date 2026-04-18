import ProjectDescription

let project = Project(
    name: "ClipVault",
    targets: [
        .target(
            name: "ClipVault",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.adii.ClipVault",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["App/**", "Views/**", "Models/**", "Services/**", "Utils/**", "Components/**"],
            resources: ["Assets/**"]
        )
    ]
)
