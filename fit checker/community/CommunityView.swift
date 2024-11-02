import SwiftUI

struct CommunityView: View {
    let posts = [
        Post(username: "user123", timestamp: "2 hours ago", fires: 45, rating: 87, imageName: "asap"),
        Post(username: "fashionista", timestamp: "5 hours ago", fires: 30, rating: 92, imageName: "default"),
        Post(username: "styleguru", timestamp: "1 day ago", fires: 60, rating: 75, imageName: "asap")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(posts) { post in
                        PostView(post: post)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Community")
        }
    }
}

#Preview {
    CommunityView()
}
