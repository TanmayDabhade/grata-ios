//
//  GoalCardView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import SwiftUI

struct GoalCardView: View {
    let title: String
    let detail: String?
    let day: Int
    let totalDays: Int
    let dateCreated: Date?
    let accentColor: Color
    let progress: Double

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 16) {
            // Left side: Title and Created date
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .accessibilityAddTraits(.isHeader)
                
                if let date = dateCreated {
                    Text("Created on \(date, formatter: simpleDateFormatter)")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Right side: Day badge
            Text("Day \(day)")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(accentColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(accentColor.opacity(0.15))
                )
        }
        .padding(GrataSpacing.cardPadding)
        .grataCard(cornerRadius: GrataSpacing.cardCornerRadius)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), Day \(day)")
        .accessibilityHint("Tap to view details")
    }
}

private let simpleDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    return df
}()

struct GoalCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            GoalCardView(
                title: "Learn SwiftUI",
                detail: "Master SwiftUI development",
                day: 5,
                totalDays: 30,
                dateCreated: Date(),
                accentColor: .green,
                progress: 0.17
            )
            
            GoalCardView(
                title: "Daily Exercise",
                detail: nil,
                day: 15,
                totalDays: 30,
                dateCreated: Date().addingTimeInterval(-86400 * 15),
                accentColor: .blue,
                progress: 0.5
            )
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
