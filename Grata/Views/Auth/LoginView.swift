//
//  LoginView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome to Grata")
                            .font(.largeTitle).bold()
                        Text("Let’s get you back on track")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Card with inputs
                    VStack(spacing: 16) {
                        AuthTextField(
                            placeholder: "Email",
                            systemImage: "envelope.fill",
                            text: $authVM.email,
                            field: Field.email,
                            focus: $focusedField,
                            isSecure: false,
                            submitLabel: .next,
                            onSubmit: { focusedField = .password },
                            disabled: authVM.isLoading,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress
                        )

                        AuthTextField(
                            placeholder: "Password",
                            systemImage: "lock.fill",
                            text: $authVM.password,
                            field: Field.password,
                            focus: $focusedField,
                            isSecure: true,
                            submitLabel: .go,
                            onSubmit: { focusedField = nil; Task { await authVM.login() } },
                            disabled: authVM.isLoading
                        )

                        if let error = authVM.loginError, !error.isEmpty {
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(8)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                }
                .padding()
            }
            .navigationTitle("Login")
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture { focusedField = nil }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    Button {
                        focusedField = nil
                        Task { await authVM.login() }
                    } label: {
                        HStack(spacing: 8) {
                            if authVM.isLoading { ProgressView().tint(.white) }
                            Text("Log In").bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.accentColor, Color.accentColor.opacity(0.85)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.accentColor.opacity(0.25), radius: 10, x: 0, y: 6)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(authVM.isLoading)

                    NavigationLink {
                        SignupView()
                    } label: {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .disabled(authVM.isLoading)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 12)
                .background(.ultraThinMaterial)
                .zIndex(1)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
      .environmentObject(AuthViewModel())
  }
}
