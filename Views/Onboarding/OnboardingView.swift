import SwiftUI

struct OnboardingSlide {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentIndex = 0
    @State private var showLegalConsent = false
    
    let slides = [
        OnboardingSlide(title: "Save any content you own", description: "Download videos, photos, reels, and stories directly to your device with one click.", imageName: "Onboarding1"),
        OnboardingSlide(title: "Organize your media in one place", description: "Keep your saved content tidy with our built-in high-fidelity library viewer.", imageName: "Onboarding2"),
        OnboardingSlide(title: "Access it offline, anytime", description: "No internet? No problem. All your saved media is stored securely on device.", imageName: "Onboarding3")
    ]
    
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            // Dynamic Background Glow
            Circle()
                .fill(currentIndex == 0 ? Theme.primary : (currentIndex == 1 ? Color.purple : Color.blue))
                .frame(width: 450)
                .blur(radius: 140)
                .opacity(0.18)
                .offset(x: -120, y: -250)
                .animation(.easeInOut(duration: 1.2), value: currentIndex)
            
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 40) {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Theme.primary.opacity(0.15))
                                    .frame(width: 280, height: 280)
                                    .blur(radius: 40)
                                
                                Image(slides[index].imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 240, height: 240)
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .shadow(color: Theme.primary.opacity(0.5), radius: 30, x: 0, y: 15)
                            }
                            
                            VStack(spacing: 16) {
                                Text(slides[index].title)
                                    .font(.system(size: 34, weight: .black, design: .rounded))
                                    .foregroundColor(Theme.text)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                
                                Text(slides[index].description)
                                    .font(.system(size: 19))
                                    .foregroundColor(Theme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 44)
                                    .lineSpacing(6)
                            }
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Button(action: {
                    if currentIndex == slides.count - 1 {
                        showLegalConsent = true
                    } else {
                        withAnimation(.spring()) {
                            currentIndex += 1
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }) {
                    Text(currentIndex == slides.count - 1 ? "GET STARTED" : "NEXT")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Theme.primaryGradient)
                        .cornerRadius(20)
                        .shadow(color: Theme.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showLegalConsent) {
            LegalConsentView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}
