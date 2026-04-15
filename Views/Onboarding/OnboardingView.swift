import SwiftUI

struct OnboardingSlide {
    let title: String
    let description: String
    let icon: String
}

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentIndex = 0
    @State private var showLegalConsent = false
    
    let slides = [
        OnboardingSlide(title: "Save any content you own", description: "Download videos, photos, reels, and stories directly to your device.", icon: "arrow.down.circle.fill"),
        OnboardingSlide(title: "Organize your media in one place", description: "Keep your saved content tidy with our built-in library viewer.", icon: "square.grid.2x2.fill"),
        OnboardingSlide(title: "Access it offline, anytime", description: "No internet? No problem. All your saved media is stored locally.", icon: "wifi.slash")
    ]
    
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            // Dynamic Background Glow
            Circle()
                .fill(currentIndex == 0 ? Color.blue : (currentIndex == 1 ? Color.purple : Color.orange))
                .frame(width: 400)
                .blur(radius: 120)
                .opacity(0.15)
                .offset(x: -100, y: -200)
                .animation(.easeInOut(duration: 1.0), value: currentIndex)
            
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 30) {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Theme.primary.opacity(0.1))
                                    .frame(width: 200, height: 200)
                                    .blur(radius: 20)
                                
                                Image(systemName: slides[index].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(Theme.primaryGradient)
                            }
                            
                            VStack(spacing: 12) {
                                Text(slides[index].title)
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(Theme.text)
                                    .multilineTextAlignment(.center)
                                
                                Text(slides[index].description)
                                    .font(.system(size: 18))
                                    .foregroundColor(Theme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .lineSpacing(4)
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
