//
//  NotificationsView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import SwiftUI

struct NotificationsView: View {
    @ObservedObject var goalViewModel: GoalViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    Text("Notifications")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    Text("Recent")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    // List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(goalViewModel.notifications) { notif in
                                NotificationRowView(notification: notif)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
