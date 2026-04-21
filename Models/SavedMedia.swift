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
    var platform: String
    var dateSaved: Date
    
    var mediaType: MediaType {
        get { MediaType(rawValue: mediaTypeString) ?? .video }
        set { mediaTypeString = newValue.rawValue }
    }
    
    var platformName: String {
        platform // Direct access to stored property
    }
    
    init(id: UUID = UUID(), title: String, originalURL: String, localFilePath: String? = nil, thumbnailData: Data? = nil, mediaType: MediaType, platform: String = "Generic", dateSaved: Date = Date()) {
        self.id = id
        self.title = title
        self.originalURL = originalURL
        self.localFilePath = localFilePath
        self.thumbnailData = thumbnailData
        self.mediaTypeString = mediaType.rawValue
        self.platform = platform
        self.dateSaved = dateSaved
    }
}
