# ClipVault

"Your content, saved forever."

ClipVault is a clean, modern personal media manager that allows users to save, organize, and manage their own social media content offline. Built fully with SwiftUI and SwiftData.

## Tech Stack
- **UI:** SwiftUI (iOS 16+)
- **Storage:** SwiftData and FileManager
- **Media:** AVKit, PhotosUI
- **Networking:** URLSession

## Setup Instructions
1. Ensure you have **Tuist 4** installed (`curl -Ls https://install.tuist.io | bash`).
2. Open your terminal in the project root.
3. Run `tuist install` to fetch dependencies (Firebase).
4. Run `tuist generate` to create the Xcode project.
5. Open `ClipVault.xcworkspace` and run the app on an iOS Simulator or device (iOS 17.0+).

## Features
- Save specific media links locally.
- Full-screen Video Player & Photo simulation.
- Dark mode first aesthetic with `Electric Indigo` accent color.
- Complete onboarding and legal compliance built-in.
