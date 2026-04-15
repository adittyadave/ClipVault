import Foundation
import FirebaseAnalytics

class FirebaseService {
    static let shared = FirebaseService()
    
    private init() {}
    
    /// Logs a media save event.
    func logMediaSave(platform: String, fileType: String) {
        Analytics.logEvent("media_save", parameters: [
            "platform": platform,
            "file_type": fileType,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ])
    }
    
    /// Logs onboarding completion.
    func logOnboardingComplete() {
        Analytics.logEvent(AnalyticsEventTutorialComplete, parameters: nil)
    }
}
