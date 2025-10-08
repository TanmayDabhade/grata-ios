//
//  GrataApp.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI

@main
struct GrataApp: App {
    // Core-Data
    let persistenceController = PersistenceController.shared
    // Auth state (Supabase)
    @StateObject private var authVM = AuthViewModel()
    // onboarding flag
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    var body: some Scene {
        WindowGroup {
            Group {
                if !hasOnboarded {
                    OnboardingView()
                } else if authVM.isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authVM)
            .environment(\.managedObjectContext,
                          persistenceController.container.viewContext)
            .task {
                // restoreSession is async
                await authVM.restoreSession()
            }
        }
    }
}
