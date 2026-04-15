import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var linkText = ""
    @State private var isProcessing = false
    @Query(sort: \SavedMedia.dateSaved, order: .reverse) private var recentMedia: [SavedMedia]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                Theme.bg.ignoresSafeArea()
                
                Circle()
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 400)
                    .blur(radius: 100)
                    .offset(x: -200, y: -300)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Vault")
                                .font(.system(size: 40, weight: .black))
                                .foregroundStyle(Theme.primaryGradient)
                            
                            Text("Capture and save your favorite clips.")
                                .font(.subheadline)
                                .foregroundColor(Theme.secondaryText)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        // Input Area (Glassmorphism)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Save New Content")
                                .font(.headline)
                                .foregroundColor(Theme.text)
                            
                            LinkInputBar(text: $linkText) {
                                if !linkText.isEmpty {
                                    isProcessing = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Recents Section
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("Recent Saves")
                                    .font(.title3.bold())
                                    .foregroundColor(Theme.text)
                                
                                Spacer()
                                
                                Button(action: { /* Navigate to Library */ }) {
                                    Text("See All")
                                        .font(.subheadline.bold())
                                        .foregroundColor(Theme.primary)
                                }
                            }
                            .padding(.horizontal)
                            
                            if recentMedia.isEmpty {
                                EmptyStateView()
                                    .padding(.top, 20)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(recentMedia.prefix(5)) { media in
                                            MediaCardView(media: media)
                                                .frame(width: 180, height: 260)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isProcessing) {
                ProcessLinkView(url: linkText, isPresented: $isProcessing)
                    .onDisappear {
                        linkText = ""
                    }
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "link.badge.plus")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(Theme.primaryGradient)
            
            Text("No clips saved yet.")
                .font(.subheadline)
                .foregroundColor(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Theme.surface.opacity(0.5))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
