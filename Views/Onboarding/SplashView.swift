import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            
            VStack {
                Image("LaunchLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(color: Theme.primary.opacity(0.4), radius: 20, x: 0, y: 10)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("ClipVault")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(Theme.text)
                    .padding(.top, 24)
                    .opacity(opacity)
                    .tracking(2)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
