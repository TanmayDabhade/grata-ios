//
//  Community.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//


import Foundation

struct Community: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let group: String
    var isJoined: Bool
}
