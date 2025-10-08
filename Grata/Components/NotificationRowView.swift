//
//  NotificationRowView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import SwiftUI

struct NotificationRowView: View {
    let notification: NotificationItem

    var typeColor: Color {
        switch notification.type {
        case .comment: return .blue
        case .like: return .green
        case .follow: return .orange
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(typeColor)
                    .frame(width: 32, height: 32)
                Image(systemName: notification.iconName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(notification.type.rawValue.capitalized)
                        .font(.caption)
                        .bold()
                        .foregroundColor(typeColor)
                        .padding(.trailing, 4)
                    if !notification.isRead {
                        Circle()
                            .fill(typeColor)
                            .frame(width: 8, height: 8)
                    }
                }
                Text("From: \(notification.sender)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                Text("Target: \(notification.target)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
                Text(notification.message)
                    .foregroundColor(notification.isRead ? .white.opacity(0.7) : .white)
                    .font(.body)
                    .bold(!notification.isRead)
                Text(notification.date, style: .date)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
            }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}
