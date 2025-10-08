//
//  AuthViewModel.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import Foundation
import Supabase
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: – Published properties for binding in your views
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var loginError: String?
    @Published var isLoading: Bool = false
    @Published var justLoggedIn: Bool = false

    // MARK: – Supabase client
    private let client = SupabaseManager.shared.client

    // MARK: – Public API

    /// Attempt to log in with the current `email` & `password`.
    /// On success `isLoggedIn` becomes true; on failure `loginError` is set.
    func login() async {
        guard validateInputs() else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let session = try await client.auth.signIn(email: email, password: password)
            if let userEmail = session.user.email { self.email = userEmail }
            justLoggedIn = true
            withAnimation(.easeInOut) { isLoggedIn = true }
            loginError = nil
        } catch {
            loginError = error.localizedDescription
        }
    }

    /// Attempt to create a new account with the current `email` & `password`.
    /// On success `isLoggedIn` becomes true if `session` was returned.
    func signup() async {
        guard validateInputs() else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let authResponse = try await client.auth.signUp(email: email, password: password)
            let signedIn = (authResponse.session != nil)
            withAnimation(.easeInOut) { isLoggedIn = signedIn }
            if !signedIn {
                loginError = "Check your email to confirm your account."
            } else {
                loginError = nil
            }
        } catch {
            loginError = error.localizedDescription
        }
    }

    /// Restore an existing session from the built-in storage adapter.
    /// (This will throw if there's no stored session or something went wrong.)
    func restoreSession() async {
        do {
            let session = try await client.auth.session
            if let userEmail = session.user.email { self.email = userEmail }
            isLoggedIn = true
            loginError = nil
        } catch {
            // if it threw, there was no valid session
            isLoggedIn = false
            // don’t surface restore errors to user on cold start
        }
    }

    /// Sign out the current user.
    func signOut() {
        Task {
            do {
                try await client.auth.signOut()
                withAnimation(.easeInOut) { isLoggedIn = false }
                email = ""
                password = ""
                loginError = nil
                justLoggedIn = false
            } catch {
                loginError = error.localizedDescription
            }
        }
    }

    // MARK: – Helpers
    private func validateInputs() -> Bool {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            loginError = "Email and password are required."
            return false
        }
        loginError = nil
        return true
    }
}
