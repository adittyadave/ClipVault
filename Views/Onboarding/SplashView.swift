import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.0
    @State private var textTranslate: CGFloat = 20
    @State private var bgOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Premium background gradient
            Theme.bg.ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [Theme.primary.opacity(0.12), .clear]),
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            .opacity(bgOpacity)
            
            // Subtle ambient particles
            GeometryReader { geo in
                ForEach(0..<10) { i in
                    Circle()
                        .fill(Theme.primary.opacity(0.1))
                        .frame(width: CGFloat.random(in: 4...12))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                        .blur(radius: 2)
                }
            }
            .opacity(bgOpacity)
            
            VStack(spacing: 0) {
                Image("LaunchLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .shadow(color: Theme.primary.opacity(0.4), radius: 25, x: 0, y: 15)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("ClipVault")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(Theme.text)
                    .padding(.top, 28)
                    .tracking(2)
                    .opacity(opacity)
                    .offset(y: textTranslate)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                bgOpacity = 1.0
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                scale = 1.0
                opacity = 1.0
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0).delay(0.2)) {
                textTranslate = 0
            }
        }
    }
}
