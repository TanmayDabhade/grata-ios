//
//  CommunityCardView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import SwiftUI

struct CommunityCardView: View {
    let title: String
    let detail: String
    let group: String
    let isJoined: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title + Group badge
            HStack {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                Text(group)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.08))
                    .foregroundColor(.primary)
                    .clipShape(Capsule())
            }

            // Detail text
            Text(detail)
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Join/Joined button
            Button(action: action) {
                Text(isJoined ? "Joined" : "Join")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isJoined ? Color.primary.opacity(0.08) : Color.accentColor)
                    )
                    .foregroundColor(isJoined ? .primary : .white)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(GrataSpacing.cardPadding)
        .grataCard(cornerRadius: GrataSpacing.cardCornerRadius)
    }
}
