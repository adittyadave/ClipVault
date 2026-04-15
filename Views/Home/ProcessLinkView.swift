import SwiftUI
import SwiftData

struct ProcessLinkView: View {
    let url: String
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    
    @State private var status = "Preparing..."
    @State private var isAnimating = false
    @State private var progress: Double = 0.0
    @State private var isSuccess = false
    @State private var isError = false
    
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Main Animated Icon
                ZStack {
                    Circle()
                        .stroke(Theme.surface, lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    if isSuccess {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                            .transition(.scale.combined(with: .opacity))
                    } else if isError {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(Theme.primaryGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 120, height: 120)
                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                            .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: isAnimating)
                    }
                }
                
                VStack(spacing: 12) {
                    Text(status)
                        .font(.title3.bold())
                        .foregroundColor(Theme.text)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if !isSuccess && !isError {
                        ProgressView(value: progress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: Theme.primary))
                            .frame(width: 200)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                if isSuccess || isError {
                    Button(action: { isPresented = false }) {
                        Text(isSuccess ? "Done" : "Try Again")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(isSuccess ? Color.green : Theme.primary)
                            .cornerRadius(25)
                            .shadow(color: (isSuccess ? Color.green : Theme.primary).opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .font(.subheadline.bold())
                            .foregroundColor(Theme.secondaryText)
                    }
                }
            }
            .animation(Theme.spring, value: isSuccess)
            .animation(Theme.spring, value: isError)
        }
        .onAppear {
            isAnimating = true
            startProcessing()
        }
    }
    
    private func startProcessing() {
        Task {
            do {
                let lowerURL = url.lowercased()
                let isInstagram = lowerURL.contains("instagram") || lowerURL.contains("instagr.am")
                let isTikTok = lowerURL.contains("tiktok.com") || lowerURL.contains("vm.tiktok")
                let isPinterest = lowerURL.contains("pinterest.com") || lowerURL.contains("pin.it")
                let isYouTube = lowerURL.contains("youtube.com/shorts") || lowerURL.contains("youtu.be")
                
                let platformName = isInstagram ? "Instagram" : (isTikTok ? "TikTok" : (isPinterest ? "Pinterest" : (isYouTube ? "YouTube" : "source")))
                status = "Connecting to \(platformName)..."
                try await Task.sleep(nanoseconds: 1_000_000_000)
                progress = 0.2
                
                if isInstagram {
                    status = "Resolving high-quality Reel..."
                } else if isTikTok {
                    status = "Bypassing TikTok watermarks..."
                } else if isPinterest {
                    status = "Finding high-res Pin..."
                } else if isYouTube {
                    status = "Resolving 4K Shorts stream..."
                } else {
                    status = "Extracting media info..."
                }
                
                try await Task.sleep(nanoseconds: 1_200_000_000)
                progress = 0.5
                
                if isInstagram {
                    status = "Persisting to Vault storage..."
                } else if isTikTok {
                    status = "Optimizing for offline viewing..."
                } else if isPinterest {
                    status = "Generating photo preview..."
                } else if isYouTube {
                    status = "Decrypting media signature..."
                } else {
                    status = "Downloading locally..."
                }
                // Actual download happens here
                try await DownloadService.shared.downloadMedia(url: url, context: modelContext)
                
                progress = 1.0
                status = "Successfully saved!"
                withAnimation {
                    isSuccess = true
                }
                
                // Auto close on success after a short delay
                try await Task.sleep(nanoseconds: 1_500_000_000)
                isPresented = false
                
            } catch {
                withAnimation {
                    isError = true
                    status = "Something went wrong.\nPlease check the link."
                }
            }
        }
    }
}
