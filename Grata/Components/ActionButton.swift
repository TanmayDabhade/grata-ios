import SwiftUI
import UIKit

struct ActionButton: View {
    let title: String
    let systemImage: String
    let accentColor: Color
    let action: () -> Void
    let accessibilityLabel: String

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
                action()
            }
        }) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(accentColor)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(accentColor.opacity(0.12))
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .opacity(isPressed ? 0.7 : 1.0)
                .shadow(color: accentColor.opacity(0.18), radius: 6, x: 0, y: 2)
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(
            title: "Edit",
            systemImage: "pencil",
            accentColor: .green,
            action: {},
            accessibilityLabel: "Edit goal"
        )
        .preferredColorScheme(.dark)
    }
}
