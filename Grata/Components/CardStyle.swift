// filepath: /Users/tanmay/Coding/iOS/Grata/Grata/Components/CardStyle.swift
import SwiftUI

// Design tokens
enum GrataSpacing {
    static let cardPadding: CGFloat = 20
    static let cardCornerRadius: CGFloat = 20
}

enum GrataStyleTokens {
    static let green = Color(red: 0.3, green: 0.7, blue: 0.4)
    static let blue = Color(red: 0.2, green: 0.5, blue: 0.9)

    static let progressGradient = LinearGradient(
        gradient: Gradient(colors: [green, blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// Unified card container modifier
struct GrataCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var cornerRadius: CGFloat = GrataSpacing.cardCornerRadius

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(colorScheme == .dark ? Color(white: 0.12) : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func grataCard(cornerRadius: CGFloat = GrataSpacing.cardCornerRadius) -> some View {
        modifier(GrataCardModifier(cornerRadius: cornerRadius))
    }
}
