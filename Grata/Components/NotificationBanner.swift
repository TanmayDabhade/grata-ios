import SwiftUI

struct NotificationBanner: View {
    @Binding var isPresented: Bool
    var title: String
    var systemImage: String = "checkmark.circle.fill"

    var body: some View {
        if isPresented {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundColor(.green)
                Text(title)
                    .font(.subheadline).bold()
                    .foregroundColor(.primary)
                Spacer(minLength: 0)
                Button(action: { withAnimation { isPresented = false } }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
            .zIndex(2)
        }
    }
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NotificationBanner(isPresented: .constant(true), title: "Logged in successfully")
            Spacer()
        }
        .padding(.top)
        .background(Color(white: 0.95))
        .previewLayout(.sizeThatFits)
    }
}
