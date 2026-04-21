// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "FirebaseAnalytics": .staticFramework,
            "FirebaseCore": .staticFramework,
            "FirebaseInstallations": .staticFramework,
            "GoogleAppMeasurement": .staticFramework,
            "GoogleUtilities": .staticFramework,
            "nanopb": .staticFramework
        ]
    )
#endif

let package = Package(
    name: "ClipVault",
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0")
    ]
)
