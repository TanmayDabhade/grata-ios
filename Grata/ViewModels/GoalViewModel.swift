//
//  GoalViewModel.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import Foundation
import CoreData

class GoalViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var comments: [Comment] = []
    @Published var notifications: [NotificationItem] = []
    @Published var showAddGoal: Bool = false

    private let viewContext = PersistenceController.shared.container.viewContext

    init() {
        fetchGoals()
    }

    func fetchGoals() {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        let sort = NSSortDescriptor(keyPath: \Goal.dateCreated, ascending: false)
        request.sortDescriptors = [sort]

        do {
            goals = try viewContext.fetch(request)
        } catch {
            print("Error fetching goals:", error)
        }
    }

    func addGoal(title: String, detail: String?) {
        let newGoal = Goal(context: viewContext)
        newGoal.id = UUID()
        newGoal.title = title
        newGoal.detail = detail
        newGoal.dateCreated = Date()

        save()
        fetchGoals()
    }

    func deleteGoal(at offsets: IndexSet) {
        offsets.map { goals[$0] }.forEach(viewContext.delete)
        save()
        fetchGoals()
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context:", error)
        }
    }

    // Helper to add notification
    private func addNotification(type: NotificationType, sender: String, target: String, iconName: String, message: String) {
        let notification = NotificationItem(type: type, sender: sender, target: target, iconName: iconName, message: message)
        notifications.insert(notification, at: 0)
    }

    // Add a new comment
    func addComment(username: String, avatarURL: String?, text: String) {
        let comment = Comment(username: username, avatarURL: avatarURL, text: text, timestamp: Date())
        comments.append(comment)
        addNotification(type: .comment, sender: username, target: "Goal", iconName: "bubble.left", message: "\(username) commented: \(text)")
    }

    // Add a new comment with media
    func addComment(username: String, avatarURL: String?, text: String, mediaURLs: [URL]? = nil) {
        let comment = Comment(username: username, avatarURL: avatarURL, text: text, timestamp: Date(), mediaURLs: mediaURLs)
        comments.append(comment)
        addNotification(type: .comment, sender: username, target: "Goal", iconName: "bubble.left", message: "\(username) commented: \(text)")
    }

    // Like a comment
    func likeComment(_ comment: Comment) {
        if let index = comments.firstIndex(of: comment) {
            comments[index].likes += 1
            addNotification(type: .like, sender: "You", target: comment.username, iconName: "hand.thumbsup", message: "You liked \(comment.username)'s comment")
        }
    }

    // Follow a goal (stub)
    func followGoal(username: String, goalTitle: String) {
        addNotification(type: .follow, sender: username, target: goalTitle, iconName: "person.badge.plus", message: "\(username) followed goal: \(goalTitle)")
    }

    // Report a comment
    func reportComment(_ comment: Comment) {
        if let index = comments.firstIndex(of: comment) {
            comments[index].isReported = true
        }
    }

    // Add a reply to a comment
    func replyToComment(_ parent: Comment, reply: Comment) {
        if let index = comments.firstIndex(of: parent) {
            comments[index].replies.append(reply)
            addNotification(type: .comment, sender: reply.username, target: parent.username, iconName: "arrowshape.turn.up.left", message: "Reply to comment")
        }
    }

    // Stub for currentDay(for:) used in HomeView
    func currentDay(for goal: Goal) -> Int {
        // Replace with your actual logic if needed
        return 1
    }
}
