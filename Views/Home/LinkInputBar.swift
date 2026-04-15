import SwiftUI
import UIKit

struct LinkInputBar: View {
    @Binding var text: String
    var onSave: () -> Void
    @FocusState private var isFocused: Bool
    
    private let impact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "link")
                    .foregroundColor(Theme.secondaryText)
                
                TextField("Paste your link here", text: $text)
                    .foregroundColor(Theme.text)
                    .focused($isFocused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.secondaryText)
                    }
                }
            }
            .padding()
            .background(Theme.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFocused ? Theme.primary : Color.clear, lineWidth: 2)
            )
            
            Button(action: {
                impact.impactOccurred()
                onSave()
            }) {
                Text("Save")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        text.isEmpty ? 
                        Theme.primary.opacity(0.3) : 
                        Theme.primary
                    )
                    .cornerRadius(16)
                    .shadow(color: Theme.primary.opacity(text.isEmpty ? 0 : 0.4), radius: 10, x: 0, y: 5)
            }
            .disabled(text.isEmpty)
        }
    }
}
