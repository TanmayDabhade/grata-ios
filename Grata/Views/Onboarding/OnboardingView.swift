//
//  OnboardingView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/31/25.
//


import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @State private var current = 0

    private let pages: [OnboardingPage] = [
        .init(imageName: "onboard1", title: "Welcome to Grata",   subtitle: "Build habits and celebrate progress."),
        .init(imageName: "onboard2", title: "Join Communities",    subtitle: "Stay motivated with friends."),
        .init(imageName: "onboard3", title: "Track Your Goals",    subtitle: "Daily check-ins keep you on track.")
    ]

    var body: some View {
        VStack {
            TabView(selection: $current) {
                ForEach(Array(pages.enumerated()), id: \.1.id) { idx, page in
                    VStack(spacing: 30) {
                        Image(page.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                        Text(page.title)
                            .font(.title).bold()
                        Text(page.subtitle)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: current)

            HStack {
                if current < pages.count - 1 {
                    Button("Skip") {
                        hasOnboarded = true
                    }
                    Spacer()
                    Button("Next") {
                        current += 1
                    }
                } else {
                    Button("Get Started") {
                        hasOnboarded = true
                    }
                }
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
