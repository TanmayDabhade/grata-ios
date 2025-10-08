import SwiftUI

struct CommentsSectionView: View {
    let comments: [String] // Placeholder for real comment model
    let onAddComment: () -> Void

    @Environment(\.colorScheme) var colorScheme
    @State private var showAddAnimation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Comments")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .accessibilityAddTraits(.isHeader)
            if comments.isEmpty {
                Text("Be the first to comment…")
                    .foregroundColor(.primary.opacity(0.6))
                    .font(.body)
                    .accessibilityLabel("No comments yet. Be the first to comment.")
            } else {
                ForEach(comments, id: \.self) { comment in
                    Text(comment)
                        .foregroundColor(.primary)
                        .padding(.vertical, 6)
                        .accessibilityLabel("Comment: \(comment)")
                }
            }
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showAddAnimation = true
                }
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    showAddAnimation = false
                    onAddComment()
                }
            }) {
                HStack {
                    Image(systemName: "plus.bubble")
                    Text("Add Comment")
                        .fontWeight(.semibold)
                }
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.accentColor)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.accentColor.opacity(0.12))
                )
                .scaleEffect(showAddAnimation ? 0.95 : 1.0)
                .opacity(showAddAnimation ? 0.7 : 1.0)
                .shadow(color: Color.accentColor.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .accessibilityLabel("Add a comment")
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.clear)
                .background(.ultraThinMaterial)
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.12), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.accentColor.opacity(0.10), lineWidth: 1)
        )
        .padding(.horizontal)
        .transition(.opacity.combined(with: .slide))
        .accessibilityElement(children: .combine)
    }
}

struct CommentsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsSectionView(comments: [], onAddComment: {})
            .preferredColorScheme(.dark)
    }
}
