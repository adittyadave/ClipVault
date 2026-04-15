import SwiftUI
import AVKit

struct FullScreenPlayerView: View {
    let media: SavedMedia
    @Environment(\.presentationMode) var presentationMode
    
    // Resolve local URL for AVPlayer
    private var playerURL: URL? {
        guard let path = media.localFilePath else { return nil }
        // The path is stored as "Documents/media_...mp4"
        // We need the filename part
        let filename = (path as NSString).lastPathComponent
        let url = MediaManager.shared.getDocumentsDirectory().appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }
    
    private var player: AVPlayer? {
        guard let url = playerURL else { return nil }
        return AVPlayer(url: url)
    }
    
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            if media.mediaType == .photo {
                // Photo Viewer
                if let data = media.thumbnailData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.secondaryText)
                        Text("Photo Content")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            } else if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                    }
            } else {
                // Error State
                VStack(spacing: 20) {
                    Image(systemName: "video.slash.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Theme.durantaYellow)
                    Text("Media not found locally")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Button("Copy Original Link") {
                        UIPasteboard.general.string = media.originalURL
                    }
                    .padding()
                    .background(Theme.electricIndigo)
                    .cornerRadius(12)
                }
            }
            
            // Overlay Controls
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            UIPasteboard.general.string = media.originalURL
                        }) {
                            Image(systemName: "link")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            if let url = playerURL {
                                MediaManager.shared.saveVideoToCameraRoll(fileURL: url) { _, _ in }
                            }
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}
