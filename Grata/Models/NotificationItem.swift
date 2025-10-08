//
//  NotificationItem.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import Foundation

enum NotificationType: String, Codable {
    case comment, follow, like
}

struct NotificationItem: Identifiable, Codable {
    let id: UUID
    let type: NotificationType
    let sender: String
    let target: String
    let iconName: String
    let message: String
    let date: Date
    var isRead: Bool

    init(type: NotificationType, sender: String, target: String, iconName: String, message: String, date: Date = Date(), isRead: Bool = false) {
        self.id = UUID()
        self.type = type
        self.sender = sender
        self.target = target
        self.iconName = iconName
        self.message = message
        self.date = date
        self.isRead = isRead
    }
}
