//
//  UserProfileView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var vm = ProfileViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Subtle gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        colorScheme == .dark ? Color.black : Color(white: 0.98),
                        colorScheme == .dark ? Color(white: 0.05) : Color(white: 0.95)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // MARK: Header Section
                        VStack(spacing: 20) {
                            // Profile Image with subtle border
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.3, green: 0.7, blue: 0.4),
                                                Color(red: 0.2, green: 0.5, blue: 0.9)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 110, height: 110)
                                
                                Circle()
                                    .fill(colorScheme == .dark ? Color(white: 0.15) : Color.white)
                                    .frame(width: 106, height: 106)
                                
                                Text(String(authVM.email.prefix(1)).uppercased())
                                    .font(.system(size: 42, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 20, x: 0, y: 10)
                            
                            // Name & Email
                            VStack(spacing: 6) {
                                Text(authVM.email.components(separatedBy: "@").first?.capitalized ?? "User")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Text("@\(authVM.email.components(separatedBy: "@").first ?? "user")")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            
                            // Bio
                            Text("On a journey to build better habits and achieve my goals.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .lineLimit(3)
                            
                            // Action Buttons
                            HStack(spacing: 12) {
                                // Edit Profile
                                Button(action: { showingEditProfile = true }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text("Edit Profile")
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    }
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 3)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(ScaleButtonStyle())
                                
                                // Settings
                                Button(action: { showingSettings = true }) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .frame(width: 44, height: 44)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                                                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, x: 0, y: 3)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                        )
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)

                        // MARK: Stats Card
                        HStack(spacing: 0) {
                            StatView(count: vm.postsCount, label: "Posts")
                            
                            Divider()
                                .frame(height: 40)
                                .overlay(Color.primary.opacity(0.1))
                            
                            StatView(count: vm.goalsCount, label: "Goals")
                            
                            Divider()
                                .frame(height: 40)
                                .overlay(Color.primary.opacity(0.1))
                            
                            StatView(count: vm.streakCount, label: "Day Streak")
                        }
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
                        )
                        .padding(.horizontal, 20)

                        // MARK: Followers/Following Card
                        HStack(spacing: 0) {
                            VStack(spacing: 6) {
                                Text("\(vm.followers)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                Text("Followers")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Divider()
                                .frame(height: 40)
                                .overlay(Color.primary.opacity(0.1))
                            
                            VStack(spacing: 6) {
                                Text("\(vm.following)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                Text("Following")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(colorScheme == .dark ? Color(white: 0.12) : Color.white)
                                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
                        )
                        .padding(.horizontal, 20)

                        // MARK: Content Tabs
                        VStack(spacing: 20) {
                            // Custom Tab Selector
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(ProfileViewModel.ProfileTab.allCases) { tab in
                                        TabButton(
                                            title: tab.rawValue,
                                            isSelected: vm.selectedTab == tab,
                                            action: { vm.selectedTab = tab }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Tab Content
                            VStack(spacing: 16) {
                                switch vm.selectedTab {
                                case .posts:
                                    EmptyStateView(
                                        icon: "square.and.pencil",
                                        title: "No posts yet",
                                        subtitle: "Share your progress and thoughts"
                                    )
                                case .goals:
                                    if vm.userGoals.isEmpty {
                                        EmptyStateView(
                                            icon: "target",
                                            title: "No goals yet",
                                            subtitle: "Start your journey by creating a goal"
                                        )
                                    } else {
                                        ForEach(vm.userGoals) { goal in
                                            CommunityCardView(
                                                title: goal.title,
                                                detail: goal.detail,
                                                group: goal.group,
                                                isJoined: goal.isJoined,
                                                action: {
                                                    // TODO: Handle join/leave action
                                                }
                                            )
                                            .padding(.horizontal, 20)
                                        }
                                    }
                                case .likes:
                                    EmptyStateView(
                                        icon: "heart",
                                        title: "No likes yet",
                                        subtitle: "Like posts to see them here"
                                    )
                                case .badges:
                                    EmptyStateView(
                                        icon: "rosette",
                                        title: "No badges earned",
                                        subtitle: "Complete goals to unlock badges"
                                    )
                                }
                            }
                            .padding(.vertical, 10)
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileSheet()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsSheet()
            }
        }
    }
}

// MARK: - Stat View
private struct StatView: View {
    let count: Int
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text("\(count)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Tab Button
private struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: isSelected ? .semibold : .medium, design: .rounded))
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? (colorScheme == .dark ? Color(white: 0.12) : Color.white) : Color.clear)
                        .shadow(color: isSelected ? Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04) : Color.clear, radius: 8, x: 0, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isSelected ? Color.primary.opacity(0.08) : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Empty State View
private struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Edit Profile Sheet
private struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var bio = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile Information") {
                    TextField("Name", text: $name)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // TODO: Save changes
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Settings Sheet
private struct SettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authVM: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section("Account") {
                    Button("Change Password") {
                        // TODO: Change password
                    }
                    Button("Privacy Settings") {
                        // TODO: Privacy settings
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button(role: .destructive, action: {
                        authVM.signOut()
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    UserProfileView()
        .environmentObject(AuthViewModel())
        .preferredColorScheme(.dark)
}
