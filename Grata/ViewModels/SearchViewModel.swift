//
//  SearchViewModel.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var communities: [Community] = []
    
    // filter based on searchText
    var filteredCommunities: [Community] {
        guard !searchText.isEmpty else { return communities }
        return communities.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.detail.localizedCaseInsensitiveContains(searchText) ||
            $0.group.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        communities = [
            Community(title: "30-Day Fitness Challenge",
                      detail: "Get fit in 30 days with daily workouts.",
                      group: "Fitness Enthusiasts",
                      isJoined: true),
            Community(title: "Read 12 Books in a Year",
                      detail: "Join others in reading a book every month.",
                      group: "Book Lovers",
                      isJoined: false),
            Community(title: "Meditate Daily",
                      detail: "Practice mindfulness with daily meditation.",
                      group: "Mindfulness Group",
                      isJoined: true),
            // …add more as needed
        ]
    }
    
    func toggleJoin(_ community: Community) {
        guard let idx = communities.firstIndex(where: { $0.id == community.id }) else { return }
        communities[idx].isJoined.toggle()
    }
}
