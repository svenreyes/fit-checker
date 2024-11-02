import Foundation

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let timestamp: String
    let fires: Int
    let rating: Int
    let imageName: String
}
