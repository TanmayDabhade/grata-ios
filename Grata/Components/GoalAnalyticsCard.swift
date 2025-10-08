//
//  GoalAnalyticsCard.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI

struct GoalAnalyticsCard: View {
    let goals: [Goal]
    @Environment(\.colorScheme) var colorScheme
    
    // Calculate analytics data from logged progress
    private var activeGoalsCount: Int {
        goals.filter { loggedCount(for: $0) < 30 }.count
    }
    
    private var completedGoalsCount: Int {
        goals.filter { loggedCount(for: $0) >= 30 }.count
    }
    
    private var averageProgress: Double {
        guard !goals.isEmpty else { return 0 }
        let totalProgress = goals.reduce(0.0) { sum, goal in
            sum + GoalProgressStore.shared.progress(for: goal)
        }
        return totalProgress / Double(goals.count)
    }
    
    private var totalDaysWorked: Int {
        goals.reduce(0) { $0 + loggedCount(for: $1) }
    }
    
    private func loggedCount(for goal: Goal) -> Int {
        GoalProgressStore.shared.loggedCount(for: goal)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Keep up the momentum!")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Quick Stats Badge
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.orange)
                    Text("\(totalDaysWorked)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(colorScheme == .dark ? Color(white: 0.15) : Color.orange.opacity(0.1))
                )
            }
            .padding(.horizontal, GrataSpacing.cardPadding)
            .padding(.top, GrataSpacing.cardPadding)
            .padding(.bottom, 16)
            
            // Main Content
            HStack(spacing: 20) {
                // Left Side: Circular Progress Ring
                ZStack {
                    // Background Circle
                    Circle()
                        .stroke(
                            colorScheme == .dark ? Color(white: 0.15) : Color.gray.opacity(0.15),
                            lineWidth: 12
                        )
                        .frame(width: 120, height: 120)
                    
                    // Progress Circle with Gradient
                    Circle()
                        .trim(from: 0, to: averageProgress)
                        .stroke(
                            GrataStyleTokens.progressGradient,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 1.0, dampingFraction: 0.8), value: averageProgress)
                    
                    // Center Text
                    VStack(spacing: 2) {
                        Text("\(Int(averageProgress * 100))%")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Complete")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.leading, 8)
                
                // Right Side: Stats Grid
                VStack(spacing: 12) {
                    // Active Goals
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(GrataStyleTokens.green.opacity(0.15))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "target")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(GrataStyleTokens.green)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(activeGoalsCount)")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("Active Goals")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    // Completed Goals
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(GrataStyleTokens.blue.opacity(0.15))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(GrataStyleTokens.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(completedGoalsCount)")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("Completed")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, GrataSpacing.cardPadding)
            .padding(.bottom, 16)
            
            // Weekly Progress Bar Chart
            if !goals.isEmpty {
                Divider()
                    .padding(.horizontal, GrataSpacing.cardPadding)
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("This Week")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(weeklyActiveCount) active")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    // Mini Bar Chart
                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach(0..<7, id: \.self) { index in
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(GrataStyleTokens.progressGradient)
                                    .frame(height: barHeight(for: index))
                                    .frame(maxWidth: .infinity)
                                    .opacity(index <= currentWeekday ? 1.0 : 0.3)
                                
                                Text(dayLabel(for: index))
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(height: 60)
                }
                .padding(.horizontal, GrataSpacing.cardPadding)
                .padding(.bottom, GrataSpacing.cardPadding)
            }
        }
        .grataCard(cornerRadius: 24)
    }
    
    // Helper for weekly chart
    private var currentWeekday: Int {
        Calendar.current.component(.weekday, from: Date()) - 1
    }
    
    private var weeklyActiveCount: Int {
        // Placeholder: count goals created in last week; replace with per-day logs when available
        let calendar = Calendar.current
        let today = Date()
        return goals.filter { goal in
            guard let dateCreated = goal.dateCreated else { return false }
            let daysSinceCreation = calendar.dateComponents([.day], from: dateCreated, to: today).day ?? 0
            return daysSinceCreation < 7
        }.count
    }
    
    private func barHeight(for index: Int) -> CGFloat {
        // Simulated data; replace with real per-day logs when available
        let baseHeights: [CGFloat] = [30, 45, 35, 50, 40, 55, 45]
        let randomVariation = CGFloat.random(in: -5...5)
        return baseHeights[index] + randomVariation
    }
    
    private func dayLabel(for index: Int) -> String {
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        return days[index]
    }
}

// Preview
#Preview {
    ScrollView {
        GoalAnalyticsCard(goals: [])
            .padding()
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
