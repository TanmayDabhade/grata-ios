//
//  AddGoalView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: GoalViewModel

    @State private var title = ""
    @State private var detail = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                Form {
                    Section {
                        TextField("Title", text: $title)
                            .foregroundColor(.white)
                        TextField("Details (optional)", text: $detail)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.black)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        vm.addGoal(title: title, detail: detail.isEmpty ? nil : detail)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

