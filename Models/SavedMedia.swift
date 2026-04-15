import Foundation
import SwiftData

enum MediaType: String, Codable {
    case video
    case photo
    case reel
    case story
}

@Model
final class SavedMedia {
    var id: UUID
    var title: String
    var originalURL: String
    var localFilePath: String?
    var thumbnailData: Data?
    var mediaTypeString: String
    var dateSaved: Date
    
    var mediaType: MediaType {
        get { MediaType(rawValue: mediaTypeString) ?? .video }
        set { mediaTypeString = newValue.rawValue }
    }
    
    var platformName: String {
        let url = originalURL.lowercased()
        if url.contains("instagram.com") || url.contains("instagr.am") { return "Instagram" }
        if url.contains("tiktok.com") || url.contains("vm.tiktok") { return "TikTok" }
        if url.contains("youtube.com") || url.contains("youtu.be") { return "YouTube" }
        if url.contains("facebook.com") { return "Facebook" }
        return "ClipVault"
    }
    
    init(id: UUID = UUID(), title: String, originalURL: String, localFilePath: String? = nil, thumbnailData: Data? = nil, mediaType: MediaType, dateSaved: Date = Date()) {
        self.id = id
        self.title = title
        self.originalURL = originalURL
        self.localFilePath = localFilePath
        self.thumbnailData = thumbnailData
        self.mediaTypeString = mediaType.rawValue
        self.dateSaved = dateSaved
    }
}
