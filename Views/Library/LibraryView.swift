import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(sort: \SavedMedia.dateSaved, order: .reverse) private var allMedia: [SavedMedia]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedFilter: MediaType? = nil
    
    var filteredMedia: [SavedMedia] {
        if let filter = selectedFilter {
            return allMedia.filter { $0.mediaType == filter }
        }
        return allMedia
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.bg.ignoresSafeArea()
                
                // Background Glow
                Circle()
                    .fill(Theme.primary.opacity(0.1))
                    .frame(width: 300)
                    .blur(radius: 80)
                    .offset(x: 150, y: -200)
                
                VStack(spacing: 0) {
                    // Filter Scroll (Glass)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            FilterBadge(title: "All", isSelected: selectedFilter == nil) {
                                withAnimation(Theme.spring) { selectedFilter = nil }
                            }
                            
                            FilterBadge(title: "Videos", isSelected: selectedFilter == .video) {
                                withAnimation(Theme.spring) { selectedFilter = .video }
                            }
                            
                            FilterBadge(title: "Photos", isSelected: selectedFilter == .photo) {
                                withAnimation(Theme.spring) { selectedFilter = .photo }
                            }
                            
                            FilterBadge(title: "Reels", isSelected: selectedFilter == .reel) {
                                withAnimation(Theme.spring) { selectedFilter = .reel }
                            }
                            
                            FilterBadge(title: "Stories", isSelected: selectedFilter == .story) {
                                withAnimation(Theme.spring) { selectedFilter = .story }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                    }
                    .background(Color.black.opacity(0.2))
                    
                    if filteredMedia.isEmpty {
                        EmptyVaultView()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(filteredMedia) { media in
                                    NavigationLink(destination: FullScreenPlayerView(media: media)) {
                                        MediaCardView(media: media)
                                            .frame(height: 240)
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                    .contextMenu {
                                        Button(action: { /* Share action */ }) {
                                            Label("Share", systemImage: "square.and.arrow.up")
                                        }
                                        Button(action: { UIPasteboard.general.string = media.originalURL }) {
                                            Label("Copy Link", systemImage: "link")
                                        }
                                        Button(role: .destructive, action: { modelContext.delete(media) }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, 80) // Tab bar clearance
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Theme.bg, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct EmptyVaultView: View {
    var body: some View {
        Spacer()
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Theme.surface)
                    .frame(width: 140, height: 140)
                
                Image(systemName: "archivebox.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.primaryGradient)
            }
            
            VStack(spacing: 8) {
                Text("Your Vault is Empty")
                    .font(.title2.bold())
                    .foregroundColor(Theme.text)
                
                Text("Content you save will appear here.")
                    .font(.subheadline)
                    .foregroundColor(Theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        Spacer()
    }
}

struct FilterBadge: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    isSelected ? 
                    AnyView(Theme.primaryGradient) : 
                    AnyView(Theme.surface.opacity(0.8))
                )
                .foregroundColor(isSelected ? .white : Theme.secondaryText)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.05), lineWidth: 1)
                )
                .shadow(color: isSelected ? Theme.primary.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
    }
}
