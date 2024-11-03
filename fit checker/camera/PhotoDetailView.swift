import SwiftUI

struct PhotoDetailView: View {
    @State var photoItem: PhotoItem
    @ObservedObject var photoCollection: PhotoCollection

    var body: some View {
        VStack {
            Image(uiImage: photoItem.image)
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped() 
                .cornerRadius(12)
                .padding()

            Text("Rating: \(photoItem.rating)/10")
                .font(.headline)
                .padding(.bottom, 10)

            Spacer()
        }
    }
}
