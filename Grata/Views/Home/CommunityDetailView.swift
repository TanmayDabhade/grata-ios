//
//  CommunityDetailView.swift
//  Grata
//
//  Created by Tanmay Avinash Dabhade on 7/30/25.
//

import SwiftUI

struct CommunityDetailView: View {
    @ObservedObject var goal: Goal
    @ObservedObject var viewModel: GoalViewModel
    @State private var progress: Double = 0.2      // replace with real tracking
    @State private var newComment = ""
    @State private var replyTo: Comment? = nil
    @State private var selectedImages: [UIImage] = []
    @State private var showImagePicker = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(goal.title ?? "")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .padding(.horizontal)
                }
                Divider().background(Color.white.opacity(0.5))

                // Community stats
                HStack {
                    Text("Comments: \(viewModel.comments.count)")
                        .foregroundColor(.white.opacity(0.7))
                    Text("Participants: \(Set(viewModel.comments.map { $0.username }).count)")
                        .foregroundColor(.white.opacity(0.7))
                }

                // Comments
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.comments) { comment in
                            CommentView(
                                comment: comment,
                                onLike: { viewModel.likeComment(comment) },
                                onReply: { replyTo = comment },
                                onReport: { viewModel.reportComment(comment) }
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // New comment field with image picker
                VStack(spacing: 8) {
                    HStack {
                        TextField(replyTo == nil ? "Add a comment…" : "Reply to \(replyTo!.username)…", text: $newComment)
                            .textFieldStyle(.roundedBorder)
                            .frame(minHeight: 36)
                        Button {
                            showImagePicker = true
                        } label: {
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                        .accessibilityLabel("Attach image")
                        Button {
                            let mediaURLs = selectedImages.compactMap { image in
                                // Save image to temporary directory and get URL
                                let data = image.jpegData(compressionQuality: 0.8)
                                let filename = UUID().uuidString + ".jpg"
                                let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                                do {
                                    try data?.write(to: url)
                                    return url
                                } catch {
                                    return nil
                                }
                            }
                            if let parent = replyTo {
                                let reply = Comment(username: "You", avatarURL: nil, text: newComment, timestamp: Date(), mediaURLs: mediaURLs)
                                viewModel.replyToComment(parent, reply: reply)
                                replyTo = nil
                            } else {
                                viewModel.addComment(username: "You", avatarURL: nil, text: newComment, mediaURLs: mediaURLs)
                            }
                            newComment = ""
                            selectedImages = []
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                        }
                        .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImages.isEmpty)
                    }
                    .padding(.horizontal)
                    // Show selected images preview
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedImages, id: \ .self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(images: $selectedImages)
                }
            }
        }
        .navigationTitle("Community")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentView: View {
    let comment: Comment
    let onLike: () -> Void
    let onReply: () -> Void
    let onReport: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let avatarURL = comment.avatarURL, let url = URL(string: avatarURL) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Circle().fill(Color.gray)
                    }
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                } else {
                    Circle().fill(Color.gray).frame(width: 32, height: 32)
                }
                VStack(alignment: .leading) {
                    Text(comment.username)
                        .bold().foregroundColor(.white)
                    Text(comment.text)
                        .foregroundColor(.white.opacity(0.7))
                    Text("\(comment.timestamp, formatter: dateFormatter)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                Button(action: onLike) {
                    Label("\(comment.likes)", systemImage: "hand.thumbsup")
                        .foregroundColor(.green)
                }.accessibilityLabel("Like comment")
                Button(action: onReply) {
                    Image(systemName: "arrowshape.turn.up.left")
                        .foregroundColor(.blue)
                }.accessibilityLabel("Reply to comment")
                Button(action: onReport) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                }.accessibilityLabel("Report comment")
            }
            // Replies
            if !comment.replies.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(comment.replies) { reply in
                        ReplyView(reply: reply)
                    }
                }
            }
            // Display attached images in comments
            if let mediaURLs = comment.mediaURLs, !mediaURLs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(mediaURLs, id: \ .self) { url in
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Rectangle().fill(Color.gray)
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct ReplyView: View {
    let reply: Comment
    var body: some View {
        HStack {
            Circle().fill(Color.gray).frame(width: 24, height: 24)
            VStack(alignment: .leading) {
                Text(reply.username).bold().foregroundColor(.white)
                Text(reply.text).foregroundColor(.white.opacity(0.7))
                Text("\(reply.timestamp, formatter: dateFormatter)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            Spacer()
        }
        .padding(.leading, 32)
        // Display attached images in replies
        if let mediaURLs = reply.mediaURLs, !mediaURLs.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(mediaURLs, id: \ .self) { url in
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Rectangle().fill(Color.gray)
                        }
                        .frame(width: 48, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()


struct CommunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleGoal = Goal()
        sampleGoal.title = "Sample Goal"
        var sampleComment = Comment(username: "Alice", avatarURL: nil, text: "Great job!", timestamp: Date())
        let sampleReply = Comment(username: "Bob", avatarURL: nil, text: "Thanks!", timestamp: Date())
        sampleComment.replies.append(sampleReply)
        let viewModel = GoalViewModel()
        viewModel.comments = [sampleComment]
        return CommunityDetailView(goal: sampleGoal, viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}

