import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.largeTitle.bold())
                        .foregroundColor(Theme.text)
                    
                    Text("Last updated: Apr 15, 2026")
                        .font(.subheadline)
                        .foregroundColor(Theme.secondaryText)
                    
                    Text("""
                    At ClipVault, we prioritize your privacy.
                    
                    1. No Data Collection:
                    We do not harvest, collect, or store any of your personal data on external servers.
                    
                    2. Local Storage:
                    All media downloaded through ClipVault is stored locally on your device. We do not have access to your saved content.
                    
                    3. No Accounts Required:
                    You can use the app without creating an account or providing an email address.
                    
                    4. Third-Party Services:
                    The app accesses public URLs that you provide, but we do not track your requests or link them to your identity.
                    """)
                    .font(.body)
                    .foregroundColor(Theme.text)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}
