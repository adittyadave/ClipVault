import SwiftUI

struct LegalConsentView: View {
    @Binding var hasCompletedOnboarding: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            // Ambient background glow
            Circle()
                .fill(Color.yellow.opacity(0.1))
                .frame(width: 300)
                .blur(radius: 80)
                .offset(x: 0, y: -200)
            
            VStack(spacing: 32) {
                // Shield Icon with glow
                ZStack {
                    Circle()
                        .fill(Color.yellow.opacity(0.15))
                        .frame(width: 100, height: 100)
                        .blur(radius: 20)
                    
                    Image(systemName: "hand.raised.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.yellow, Color.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .padding(.top, 60)
                
                VStack(spacing: 16) {
                    Text("Legal & Compliance")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(Theme.text)
                    
                    Text("ClipVault is for personal use only. You are responsible for ensuring you have permission to save content from third-party platforms.")
                        .font(.body)
                        .foregroundColor(Theme.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    BenefitRow(icon: "checkmark.circle.fill", text: "Respect creator copyrights")
                    BenefitRow(icon: "checkmark.circle.fill", text: "Observe platform terms")
                    BenefitRow(icon: "checkmark.circle.fill", text: "Keep content private")
                }
                .padding()
                .background(Theme.surface.opacity(0.5))
                .cornerRadius(16)
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        FirebaseService.shared.logOnboardingComplete()
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        withAnimation {
                            hasCompletedOnboarding = true
                            dismiss()
                        }
                    }) {
                        Text("I AGREE & UNDERSTAND")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Theme.primaryGradient)
                            .cornerRadius(20)
                            .shadow(color: Theme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Button(action: { /* Open URL */ }) {
                        Text("Read full Terms of Use")
                            .font(.subheadline.bold())
                            .foregroundColor(Theme.secondaryText)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
                .foregroundColor(Theme.text)
        }
    }
}
