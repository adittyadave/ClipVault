import SwiftUI

struct MediaCardView: View {
    let media: SavedMedia
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Thumbnail / Background
            Group {
                if let data = media.thumbnailData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Rectangle()
                        .fill(Theme.surface)
                        .overlay(
                            Image(systemName: media.mediaType == .photo ? "photo" : "play.fill")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(Theme.secondaryText.opacity(0.5))
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Premium Overlay Gradient
            LinearGradient(
                colors: [.clear, .black.opacity(0.3), .black.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 6) {
                // Dual Badge: Platform + Media Type
                HStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: iconForPlatform(media.platformName))
                            .font(.system(size: 8, weight: .bold))
                        Text(media.platformName.uppercased())
                            .font(.system(size: 8, weight: .black))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(6)
                    
                    HStack(spacing: 4) {
                        Image(systemName: iconForType(media.mediaType))
                            .font(.system(size: 8, weight: .bold))
                        Text(media.mediaType.rawValue.uppercased())
                            .font(.system(size: 8, weight: .black))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.primary.opacity(0.6))
                    .cornerRadius(6)
                }
                .foregroundColor(.white)
                
                Text(media.title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private func iconForType(_ type: MediaType) -> String {
        switch type {
        case .video: return "play.fill"
        case .photo: return "photo.fill"
        case .reel: return "play.square.stack.fill"
        case .story: return "circle.dotted"
        }
    }
    
    private func iconForPlatform(_ platform: String) -> String {
        switch platform {
        case "Instagram": return "camera.fill"
        case "TikTok": return "music.note"
        case "YouTube": return "play.rectangle.fill"
        case "Facebook": return "f.circle.fill"
        default: return "link.circle.fill"
        }
    }
}

// Helper for Blur (iOS SwiftUI common pattern)
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
