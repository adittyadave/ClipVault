import Foundation
import SwiftData

class DownloadService {
    static let shared = DownloadService()
    
    // Enhanced platform detection logic
    func extractMedia(from urlString: String) async throws -> (String, MediaType, String) {
        // Mock network delay to simulate processing
        try await Task.sleep(nanoseconds: 1_200_000_000)
        
        let url = urlString.lowercased()
        
        if url.contains("instagram.com/reels") || url.contains("instagram.com/reel") || url.contains("instagr.am") {
            return ("Instagram Reel", .reel, "Instagram")
        } else if url.contains("tiktok.com") || url.contains("vm.tiktok") {
            return ("TikTok Video", .video, "TikTok")
        } else if url.contains("youtube.com/shorts") || url.contains("youtu.be") {
            return ("YouTube Short", .reel, "YouTube")
        } else if url.contains("pinterest.com") || url.contains("pin.it") || url.contains("photo") || url.contains("jpg") || url.contains("png") {
            return ("Pinterest Photo", .photo, "Pinterest")
        } else if url.contains("story") || url.contains("facebook.com") {
            return ("Social Story", .story, "Facebook")
        }
        
        return ("Saved Media", .video, "Generic")
    }
    
    func downloadMedia(url: String, context: ModelContext) async throws {
        let (title, type, platform) = try await extractMedia(from: url)
        
        // Log start of process
        FirebaseService.shared.logMediaSave(platform: platform, fileType: type.rawValue)
        
        // --- Real Downloader Simulation Logic ---
        // In a production app, we would use a backend to resolve the direct MP4 URL.
        // For this high-quality prototype, we use a working public URL for Instagram samples.
        let mediaURLString: String
        if platform == "Instagram" {
            mediaURLString = (type == .photo) 
                ? "https://picsum.photos/1080/1920" // Real direct image
                : "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" // Real direct video
        } else if platform == "TikTok" {
            mediaURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4" // Distinct TikTok sample
        } else if platform == "Pinterest" {
            mediaURLString = "https://picsum.photos/1080/1920" // HQ Image mock
        } else if platform == "YouTube" {
            mediaURLString = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4" // High-fidelity YouTube sample
        } else {
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
