import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultQuality") private var defaultQuality = "Auto"
    @AppStorage("autoSaveCameraRoll") private var autoSaveCameraRoll = false
    @State private var isPro = false
    
    // Storage State
    @State private var storageBytes: Int64 = 0
    @State private var storageProgress: Double = 0
    @State private var showPurgeConfirmation = false
    
    @Environment(\.modelContext) private var modelContext
    
    let qualities = ["HD", "SD", "Auto"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.bg.ignoresSafeArea()
                
                List {
                    // ... PRO Section remains Same
                    Section {
                        HStack(spacing: 16) {
                            ZStack {
                                Theme.primaryGradient
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(12)
                                
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("ClipVault Pro")
                                    .font(.headline)
                                    .foregroundColor(Theme.text)
                                
                                Text("Unlimited saves & premium features")
                                    .font(.caption)
                                    .foregroundColor(Theme.secondaryText)
                            }
                            
                            Spacer()
                            
                            Text("GO PRO")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.primary)
                                .cornerRadius(20)
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Theme.surface)
                    
                    Section(header: Text("Download Preferences").foregroundColor(Theme.secondaryText)) {
                        Picker("Default Quality", selection: $defaultQuality) {
                            ForEach(qualities, id: \.self) { quality in
                                Text(quality).tag(quality)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .listRowBackground(Theme.surface)
                        .padding(.vertical, 4)
                        
                        Toggle("Auto-Save to Camera Roll", isOn: $autoSaveCameraRoll)
                            .tint(Theme.primary)
                            .listRowBackground(Theme.surface)
                            .foregroundColor(Theme.text)
                    }
                    
                    Section(header: Text("Storage").foregroundColor(Theme.secondaryText)) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Label("Storage Used", systemImage: "internaldrive")
                                Spacer()
                                Text(MediaManager.shared.formatBytes(storageBytes))
                                    .font(.subheadline.bold())
                            }
                            .foregroundColor(Theme.text)
                            
                            ProgressView(value: storageProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: Theme.primary))
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Theme.surface)
                        
                        Button(role: .destructive, action: { showPurgeConfirmation = true }) {
                            Label("Clear Cache", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .listRowBackground(Theme.surface)
                    }
                    
                    Section(header: Text("Support").foregroundColor(Theme.secondaryText)) {
                        Button(action: { /* Support */ }) {
                            Label("Contact Support", systemImage: "envelope")
                        }
                        .foregroundColor(Theme.text)
                        .listRowBackground(Theme.surface)
                        
                        Button(action: { /* Share */ }) {
                            Label("Share ClipVault", systemImage: "square.and.arrow.up")
                        }
                        .foregroundColor(Theme.text)
                        .listRowBackground(Theme.surface)
                        
                        Button(action: { /* Rate */ }) {
                            Label("Rate on App Store", systemImage: "star")
                        }
                        .foregroundColor(Theme.text)
                        .listRowBackground(Theme.surface)
                    }
                    
                    Section(header: Text("Legal").foregroundColor(Theme.secondaryText)) {
                        NavigationLink(destination: PrivacyPolicyView()) {
                            Label("Privacy Policy", systemImage: "hand.raised")
                        }
                        .foregroundColor(Theme.text)
                        .listRowBackground(Theme.surface)
                        
                        NavigationLink(destination: TermsOfUseView()) {
                            Label("Terms of Use", systemImage: "doc.text")
                        }
                        .foregroundColor(Theme.text)
                        .listRowBackground(Theme.surface)
                        
                        Button("Restore Purchases") {
                            // Restore action
                        }
                        .font(.footnote)
                        .foregroundColor(Theme.primary)
                        .listRowBackground(Theme.surface)
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Text("Version 1.0.0 (Build 12)")
                                .font(.caption2)
                                .foregroundColor(Theme.secondaryText)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Theme.bg, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                refreshStorageStats()
            }
            .confirmationDialog("Clear All Media?", isPresented: $showPurgeConfirmation, titleVisibility: .visible) {
                Button("Clear Everything", role: .destructive) {
                    performPurge()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all saved videos and images from your library.")
            }
        }
    }
    
    private func refreshStorageStats() {
        let usage = MediaManager.shared.getClipVaultStorageUsage()
        storageBytes = usage.bytes
        storageProgress = usage.progress
    }
    
    private func performPurge() {
        do {
            // 1. Delete physical files
            try MediaManager.shared.purgeAllLocalMedia()
            
            // 2. Clear SwiftData records
            // Note: In a real app, you might want to filter, but here we purge all
            try modelContext.delete(model: SavedMedia.self)
            
            // 3. Update UI
            refreshStorageStats()
            
            print("✅ Pure Complete")
        } catch {
            print("❌ Purge Failed: \(error.localizedDescription)")
        }
    }
}
