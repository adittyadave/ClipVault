import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Use")
                        .font(.largeTitle.bold())
                        .foregroundColor(Theme.text)
                    
                    Text("Last updated: Apr 15, 2026")
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryText)
                    
                    Text("""
                    By using ClipVault, you agree to the following terms:
                    
                    1. Personal Use Only:
                    ClipVault is a tool intended solely for personal use.
                    
                    2. Copyright Compliance:
                    You must only download content that you own or have explicit permission to save. Downloading copyrighted content without authorization may violate the Terms of Service of third-party platforms and local laws.
                    
                    3. User Responsibility:
                    You are solely responsible for the links you process and the content you save to your device.
                    
                    4. No Warranty:
                    ClipVault is provided "as is" without warranty of any kind.
                    """)
                    .font(.body)
                    .foregroundColor(Theme.text)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
    }
}
