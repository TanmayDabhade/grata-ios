//
//  ProfileViewModel.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    // In a real app, pull these from Core Data or your API
    @Published var postsCount: Int = 0
    @Published var goalsCount: Int = 5
    @Published var streakCount: Int = 2
    @Published var followers: Int = 2
    @Published var following: Int = 2
    
    // For segmented control content
    @Published var selectedTab: ProfileTab = .posts
    
    enum ProfileTab: String, CaseIterable, Identifiable {
        case posts = "Posts"
        case goals = "Goals"
        case likes = "Likes"
        case badges = "Badges"
        
        var id: String { rawValue }
    }
    
    // Sample goal items for the “Goals” tab
    @Published var userGoals: [Community] = [
        .init(title: "30-Day Fitness Challenge",
              detail: "Get fit in 30 days with daily workouts.",
              group: "",
              isJoined: true),
        .init(title: "Read 12 Books in a Year",
              detail: "Join others in reading a book every month.",
              group: "",
              isJoined: true),
        .init(title: "Meditate Daily",
              detail: "Practice mindfulness with daily meditation.",
              group: "",
              isJoined: true)
    ]
}
