//
//  NotificationsViewModel.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import Foundation

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []

    init(notifications: [NotificationItem] = []) {
        self.notifications = notifications
    }
}
