//
//  MainTabView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var goalViewModel = GoalViewModel()
    @State private var showingAdd = false
    @State private var showLoginBanner = false
    

    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                NotificationsView(goalViewModel: goalViewModel)
                    .tabItem { Label("Notifications", systemImage: "bell") }
                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                UserProfileView()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
            }
            .accentColor(.white)
            .background(Color.black)

            NotificationBanner(isPresented: $showLoginBanner, title: "Logged in successfully")
                .padding(.top, 8)
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showLoginBanner)
        }
        .onAppear {
            if authVM.justLoggedIn { showAndResetLoginBanner() }
        }
        .onChange(of: authVM.isLoggedIn) { isIn in
            if isIn && authVM.justLoggedIn { showAndResetLoginBanner() }
        }
    }

    private func showAndResetLoginBanner() {
        showLoginBanner = true
        authVM.justLoggedIn = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { showLoginBanner = false }
        }
    }
}


#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
        .environment(\.managedObjectContext,
                     PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
}
