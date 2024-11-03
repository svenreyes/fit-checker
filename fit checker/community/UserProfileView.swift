import SwiftUI

struct UserProfileView: View {
    let username: String
    let posts: [Post]
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    Image("default")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.top)

                    Text("Outfits Posted")
                        .font(.headline)
                        .padding(.vertical)

                    ForEach(posts) { post in
                        PostView(post: post)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(username)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

let samplePosts = [
    Post(username: "user123", timestamp: "2 hours ago", fires: 45, rating: 87, imageName: "asap"),
    Post(username: "user123", timestamp: "1 day ago", fires: 50, rating: 82, imageName: "default")
]

#Preview {
    UserProfileView(username: "user123", posts: samplePosts)
}
