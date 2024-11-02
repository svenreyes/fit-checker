import SwiftUI

struct PostView: View {
    let post: Post
    @State private var fireCount: Int
    @State private var isLiked: Bool = false
    
    init(post: Post) {
        self.post = post
        self._fireCount = State(initialValue: post.fires)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                NavigationLink(
                    destination: UserProfileView(username: post.username, posts: sampleUserPosts)
                ) {
                    HStack {
                        Image("default")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(post.username)
                                .font(.subheadline)
                                .bold()
                            Text(post.timestamp)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "ellipsis")
                    }
                    .padding(.horizontal, 10)
                }
                
            }
            .padding(.horizontal, 8)
            
            // Main post image
            Image(post.imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
                .padding(.horizontal, 8)
            
            HStack {
                Text("Rating: \(post.rating)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    isLiked.toggle()
                    fireCount += isLiked ? 1 : -1
                }) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(isLiked ? .red : .gray)
                            .font(.system(size: 16, weight: .bold))
                        Text("\(fireCount)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

// Move sampleUserPosts outside the PostView
let sampleUserPosts = [
    Post(username: "user123", timestamp: "2 hours ago", fires: 45, rating: 87, imageName: "asap"),
    Post(username: "user123", timestamp: "1 day ago", fires: 50, rating: 82, imageName: "default")
]

#Preview {
    PostView(post: samplePost)
}

// Also move samplePost outside the #Preview closure
let samplePost = Post(username: "user123", timestamp: "2 hours ago", fires: 45, rating: 87, imageName: "asap")
