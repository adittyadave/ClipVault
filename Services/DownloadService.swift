import Foundation
import SwiftData

class DownloadService {
    static let shared = DownloadService()
    
    // Enhanced platform detection logic
    func extractMedia(from urlString: String) async throws -> (String, MediaType, String) {
        // Mock network delay to simulate processing
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        let url = urlString.lowercased()
        
        if url.contains("instagram.com/reel") || url.contains("instagr.am") {
            return ("Instagram Reel", .reel, "Instagram")
        } else if url.contains("tiktok.com") || url.contains("vm.tiktok") {
            return ("TikTok Video", .video, "TikTok")
        } else if url.contains("youtube.com/shorts") || url.contains("youtu.be") {
            return ("YouTube Short", .reel, "YouTube")
        } else if url.contains("pinterest.com/pin") || url.contains("pin.it") {
            // Pinterest can be photos or "Idea Pins" (videos)
            // For now, we simulate detecting the high-res image
            return ("Pinterest Media", .photo, "Pinterest")
        } else if url.contains("facebook.com") {
            return ("Facebook Video", .video, "Facebook")
        }
        
        return ("Saved Media", .video, "Generic")
    }
    
    func downloadMedia(url: String, context: ModelContext) async throws {
        let (title, type, platform) = try await extractMedia(from: url)
        
        // Log start of process
        FirebaseService.shared.logMediaSave(platform: platform, fileType: type.rawValue)
        
        // --- High-Fidelity Simulator Logic ---
        // In a production app, this would perform a real handshake with a backend extractor.
        let mediaURLString: String
        switch platform {
        case "Instagram":
            mediaURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        case "TikTok":
            mediaURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
        case "Pinterest":
            // Pinterest usually resolves to high-quality JPGs for simple pins
            mediaURLString = "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&q=100&w=1080&h=1920"
        case "YouTube":
            // High-fidelity YouTube sample
            mediaURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"
        default:
            mediaURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
        }
        
        guard let downloadURL = URL(string: mediaURLString) else {
            throw NSError(domain: "ClipVault", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid Media URL"])
        }
        
        // PERFORM ACTUAL DOWNLOAD
        let (data, _) = try await URLSession.shared.data(from: downloadURL)
        
        // PERSIST TO DISK
        let timestamp = Int(Date().timeIntervalSince1970)
        let ext = (type == .photo) ? "jpg" : "mp4"
        let filename = "cv_\(platform.lowercased())_\(timestamp).\(ext)"
        
        if let savedURL = MediaManager.shared.saveFile(data: data, name: filename) {
            // SAVE TO DATABASE
            let newMedia = SavedMedia(
                title: title,
                originalURL: url,
                localFilePath: "Documents/\(filename)",
                thumbnailData: (type == .photo) ? data : nil,
                mediaType: type
            )
            
            context.insert(newMedia)
        }
    }
}
