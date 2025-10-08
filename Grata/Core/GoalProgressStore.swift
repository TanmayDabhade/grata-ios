// filepath: /Users/tanmay/Coding/iOS/Grata/Grata/Core/GoalProgressStore.swift
//
//  GoalProgressStore.swift
//  Grata
//
//  Stores per-goal daily completion logs locally so UI and analytics can compute progress.
//

import Foundation
import CoreData

final class GoalProgressStore {
    static let shared = GoalProgressStore()
    private init() {}

    private let defaults = UserDefaults.standard
    private let keyPrefix = "goal_progress_"

    // MARK: - Public API

    func loggedCount(for goal: Goal) -> Int {
        guard let key = key(for: goal) else { return 0 }
        return Set(defaults.stringArray(forKey: key) ?? []).count
    }

    func isLoggedToday(for goal: Goal, calendar: Calendar = .current) -> Bool {
        guard let key = key(for: goal) else { return false }
        let todayKey = dayKey(for: Date(), calendar: calendar)
        let set = Set(defaults.stringArray(forKey: key) ?? [])
        return set.contains(todayKey)
    }

    // Returns true if a new log was saved, false if it was already logged today
    @discardableResult
    func logToday(for goal: Goal, calendar: Calendar = .current) -> Bool {
        guard let key = key(for: goal) else { return false }
        let todayKey = dayKey(for: Date(), calendar: calendar)
        var set = Set(defaults.stringArray(forKey: key) ?? [])
        let inserted = set.insert(todayKey).inserted
        defaults.set(Array(set), forKey: key)
        return inserted
    }

    func clearAllLogs(for goal: Goal) {
        guard let key = key(for: goal) else { return }
        defaults.removeObject(forKey: key)
    }

    func progress(for goal: Goal, totalDays: Int = 30) -> Double {
        guard totalDays > 0 else { return 0 }
        let count = loggedCount(for: goal)
        return min(Double(count) / Double(totalDays), 1.0)
    }

    // MARK: - Helpers

    private func key(for goal: Goal) -> String? {
        // Prefer explicit UUID if available; fallback to objectID URI for stability during a session
        if let uuid = goal.id?.uuidString {
            return keyPrefix + uuid
        }
        return keyPrefix + goal.objectID.uriRepresentation().absoluteString
    }

    private func dayKey(for date: Date, calendar: Calendar) -> String {
        // YYYY-MM-DD in user's current calendar/timezone
        var cal = calendar
        cal.timeZone = .current
        let comps = cal.dateComponents([.year, .month, .day], from: date)
        let y = comps.year ?? 0
        let m = comps.month ?? 0
        let d = comps.day ?? 0
        return String(format: "%04d-%02d-%02d", y, m, d)
    }
}
