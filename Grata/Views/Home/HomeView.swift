import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = GoalViewModel()
    @State private var progressVersion: Int = 0

    private func goalCardNavigationLink(for goal: Goal) -> some View {
        let logged = GoalProgressStore.shared.loggedCount(for: goal)
        let progress = GoalProgressStore.shared.progress(for: goal)
        let isComplete = progress >= 1.0
        return NavigationLink {
            GoalDetailView(goal: goal)
        } label: {
            GoalCardView(
                title: goal.title ?? "Untitled",
                detail: goal.detail,
                day: logged,
                totalDays: 30,
                dateCreated: goal.dateCreated,
                accentColor: isComplete ? .blue : .green,
                progress: progress
            )
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Analytics Card at the top
                    GoalAnalyticsCard(goals: viewModel.goals)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .id(progressVersion)
                    
                    // Goals List
                    ForEach(viewModel.goals) { goal in
                        goalCardNavigationLink(for: goal)
                            .id(goal.objectID) // stable identity
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .toolbar {
                Button {
                    viewModel.showAddGoal = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showAddGoal) {
                AddGoalView(vm: viewModel)
            }
            .onReceive(NotificationCenter.default.publisher(for: .goalProgressUpdated)) { _ in
                // Trigger a refresh when any goal logs progress
                withAnimation { progressVersion += 1 }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
