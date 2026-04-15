import Foundation
import PhotosUI

class MediaManager {
    static let shared = MediaManager()
    
    func saveVideoToCameraRoll(fileURL: URL, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                completion(false, NSError(domain: "ClipVault", code: 1, userInfo: [NSLocalizedDescriptionKey: "Photo library access denied"]))
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }) { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// Saves raw data to the local Documents directory and returns the absolute URL.
    func saveFile(data: Data, name: String) -> URL? {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        do {
            try data.write(to: url)
            return url
        } catch {
            print("❌ Disk Write Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /// Checks if a file exists in the Documents directory.
    func fileExists(name: String) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    /// Calculates the total storage used by files starting with "cv_"
    func getClipVaultStorageUsage() -> (bytes: Int64, progress: Double) {
        let docURL = getDocumentsDirectory()
        let softLimit: Int64 = 500 * 1024 * 1024 // 500MB Soft Limit
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileSizeKey])
            let vaultFiles = fileURLs.filter { $0.lastPathComponent.hasPrefix("cv_") }
            
            var totalBytes: Int64 = 0
            for fileURL in vaultFiles {
                let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                totalBytes += Int64(resourceValues.fileSize ?? 0)
            }
            
            let progress = min(Double(totalBytes) / Double(softLimit), 1.0)
            return (totalBytes, progress)
        } catch {
            print("❌ Storage Calc Error: \(error.localizedDescription)")
            return (0, 0)
        }
    }
    
    /// Permanently deletes all media files from the Documents directory.
    func purgeAllLocalMedia() throws {
        let docURL = getDocumentsDirectory()
        let fileURLs = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: nil)
        let vaultFiles = fileURLs.filter { $0.lastPathComponent.hasPrefix("cv_") }
        
        for fileURL in vaultFiles {
            try FileManager.default.removeItem(at: fileURL)
        }
        print("🗑️ Media Purge Complete")
    }
    
    /// Formats bytes into a human-readable string.
    func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
