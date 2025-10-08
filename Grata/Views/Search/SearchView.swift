//
//  SearchView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import SwiftUI

import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()

    var body: some View {
        NavigationStack {
            Text("Search for challenges or communities")
                .foregroundColor(.gray)
                .navigationTitle("Search")
        }
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

