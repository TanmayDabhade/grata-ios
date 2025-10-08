import Foundation

struct Comment: Identifiable, Codable, Equatable {
    let id: UUID
    let username: String
    let avatarURL: String?
    let text: String
    let timestamp: Date
    var likes: Int
    var replies: [Comment]
    var isReported: Bool
    var mediaURLs: [URL]?
    
    init(id: UUID = UUID(), username: String, avatarURL: String? = nil, text: String, timestamp: Date = Date(), likes: Int = 0, replies: [Comment] = [], isReported: Bool = false, mediaURLs: [URL]? = nil) {
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.text = text
        self.timestamp = timestamp
        self.likes = likes
        self.replies = replies
        self.isReported = isReported
        self.mediaURLs = mediaURLs
    }
}
