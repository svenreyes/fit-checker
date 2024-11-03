import SwiftUI

struct PhotoDetailView: View {
    let photo: UIImage
    let rating: Int
    
    var body: some View {
        VStack {
            Text("Rating: \(rating)/10")
                .font(.headline)
                .padding(.bottom, 5)
                .padding(.top, 10)
                .bold()
            Image(uiImage: photo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    }
                }
        }
    }
}
