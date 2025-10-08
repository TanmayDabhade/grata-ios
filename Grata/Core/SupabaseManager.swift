//
//  SupabaseManager.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/31/25.
//


import Supabase
import Foundation


struct SupabaseManager {
  static let shared = SupabaseManager()

  let client: SupabaseClient

  private init() {
    // TODO: replace these with your real keys
    let url = URL(string: "https://nrpiswzkmwjqjfrouuff.supabase.co")!
    let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ycGlzd3prbXdqcWpmcm91dWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE4ODA1NDEsImV4cCI6MjA2NzQ1NjU0MX0.JjzAEpPOsCgqZfgpNk0r49YoNsTVeN9kMGXtuvPL9Vk"

    client = SupabaseClient(supabaseURL: url, supabaseKey: key)
  }
}
