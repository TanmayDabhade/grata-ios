//
//  GoalDetailView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI
import UIKit

struct GoalDetailView: View {
    @ObservedObject var goal: Goal
    @State private var comments: [String] = [] // Placeholder for real comments
    @State private var showCommentSheet = false
    @Environment(\.colorScheme) var colorScheme
    // Track local changes to force view refresh when logging
    @State private var progressVersion: Int = 0

    // Subtle accent color - mostly monochromatic with a hint of color
    var accentColor: Color {
        let progress = progressFraction
        return progress >= 1.0 ? Color(red: 0.2, green: 0.5, blue: 0.9) : Color(red: 0.3, green: 0.7, blue: 0.4)
    }

    // Progress derived from GoalProgressStore
    private var loggedCount: Int {
        GoalProgressStore.shared.loggedCount(for: goal)
    }
    private var isLoggedToday: Bool {
        GoalProgressStore.shared.isLoggedToday(for: goal)
    }
    private var progressFraction: Double {
        min(Double(loggedCount) / 30.0, 1.0)
    }

    var body: some View {
        ZStack {
            // Minimal gradient background - very subtle
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.black : Color(white: 0.98),
                    colorScheme == .dark ? Color(white: 0.05) : Color(white: 0.95)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // Hero section - Goal Title & Meta
                    VStack(spacing: 16) {
                        // Title
                        Text(goal.title ?? "Untitled Goal")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .padding(.horizontal)

                        // Description
                        if let detail = goal.detail, !detail.isEmpty {
                            Text(detail)
                                .font(.system(size: 17, weight: .regular, design: .default))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(4)
                                .padding(.horizontal, 24)
                        }

                        // Created date
                        if let date = goal.dateCreated {
                            Text("Started \(date, formatter: relativeDateFormatter)")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary.opacity(0.6))
                                .padding(.top, 4)
                        }
                    }
                    .padding(.top, 24)

                    // Progress Card - Monochromatic with subtle accent
                    VStack(spacing: 20) {
                        // Day counter
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Progress")
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                                    .foregroundColor(.secondary)
                                    .textCase(.uppercase)
                                    .tracking(0.5)

                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("\(loggedCount)")
                                        .font(.system(size: 48, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)

                                    Text("/ 30")
                                        .font(.system(size: 24, weight: .medium, design: .rounded))
                                        .foregroundColor(.secondary.opacity(0.6))

                                    Text("days")
                                        .font(.system(size: 17, weight: .regular, design: .rounded))
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 4)
                                }
                            }

                            Spacer()

                            // Circular progress indicator
                            ZStack {
                                Circle()
                                    .stroke(Color.primary.opacity(0.08), lineWidth: 8)
                                    .frame(width: 80, height: 80)

                                Circle()
                                    .trim(from: 0, to: progressFraction)
                                    .stroke(accentColor.opacity(0.9), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progressVersion)

                                Text("\(Int(progressFraction * 100))%")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                        }

                        // Linear progress bar - subtle
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.primary.opacity(0.06))
                                    .frame(height: 12)

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [accentColor.opacity(0.8), accentColor]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * progressFraction, height: 12)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progressVersion)
                            }
                        }
                        .frame(height: 12)

                        // Log Today button
                        Button(action: logTodayAction) {
                            HStack(spacing: 8) {
                                Image(systemName: isLoggedToday ? "checkmark.circle.fill" : "plus.circle.fill")
                                Text(isLoggedToday ? "Logged for Today" : "Log Today")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(isLoggedToday ? .secondary : .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(isLoggedToday ? Color.primary.opacity(0.08) : accentColor)
                            )
                        }
                        .disabled(isLoggedToday || loggedCount >= 30)
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 20)

                    // Actions - Minimal, monochromatic
                    HStack(spacing: 12) {
                        // Share button - prominent action
                        Button(action: { /* TODO: Share action */ }) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Share")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 3)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        // More menu (Edit & Delete)
                        Menu {
                            Button(action: { /* TODO: Edit action */ }) {
                                Label("Edit Goal", systemImage: "pencil")
                            }
                            
                            Divider()
                            
                            Button(role: .destructive, action: { /* TODO: Delete action */ }) {
                                Label("Delete Goal", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 3)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Comments Section - Clean and minimal
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reflections")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.primary)

                        if comments.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary.opacity(0.6))

                                Text("No reflections yet")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)

                                Text("Share your thoughts and progress")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            // Comments list would go here
                            ForEach(comments, id: \.self) { comment in
                                Text(comment)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.primary.opacity(0.04))
                                    .cornerRadius(12)
                            }
                        }

                        // Add comment button
                        Button(action: { showCommentSheet = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18))
                                Text("Add Reflection")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(accentColor.opacity(0.08))
                            .cornerRadius(14)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCommentSheet) {
            CommentSheetView(onSubmit: { comment in
                comments.append(comment)
                showCommentSheet = false
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: .goalProgressUpdated)) { _ in
            // Ensure view updates when progress changes from elsewhere
            progressVersion += 1
        }
    }

    private func logTodayAction() {
        guard !isLoggedToday, loggedCount < 30 else { return }
        let didLog = GoalProgressStore.shared.logToday(for: goal)
        if didLog {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            progressVersion += 1
            NotificationCenter.default.post(name: .goalProgressUpdated, object: goal.objectID)
        }
    }
}

// MARK: - Minimal Action Button
struct MinimalActionButton: View {
    let icon: String
    let label: String
    var isDestructive: Bool = false
    let action: () -> Void

    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            action()
        }) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isDestructive ? .red : .primary)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isDestructive ? Color.red.opacity(0.1) : Color.primary.opacity(0.06))
                    )

                Text(label)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(isDestructive ? .red : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 10, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Comment Sheet View
struct CommentSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var commentText = ""
    let onSubmit: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextEditor(text: $commentText)
                    .font(.system(size: 16, weight: .regular))
                    .padding()
                    .frame(height: 200)
                    .background(Color.primary.opacity(0.04))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )

                Button(action: {
                    if !commentText.isEmpty {
                        onSubmit(commentText)
                    }
                }) {
                    Text("Add Reflection")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(commentText.isEmpty ? Color.gray : Color.accentColor)
                        )
                }
                .disabled(commentText.isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle("Add Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Scale Button Style

// MARK: - Date Formatter
private let relativeDateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    df.doesRelativeDateFormatting = true
    return df
}()

// MARK: - Preview
#if DEBUG
struct GoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let sampleGoal = Goal(context: context)
        sampleGoal.title = "Learn SwiftUI"
        sampleGoal.detail = "Master modern iOS development with SwiftUI and build beautiful, responsive apps."
        sampleGoal.dateCreated = Calendar.current.date(byAdding: .day, value: -5, to: Date())

        return Group {
            NavigationView {
                GoalDetailView(goal: sampleGoal)
            }
            .preferredColorScheme(.dark)

            NavigationView {
                GoalDetailView(goal: sampleGoal)
            }
            .preferredColorScheme(.light)
        }
    }
}
#endif
