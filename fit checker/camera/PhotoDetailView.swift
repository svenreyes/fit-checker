import SwiftUI

struct PhotoDetailView: View {
    @State var photoItem: PhotoItem
    @ObservedObject var photoCollection: PhotoCollection

    var body: some View {
        VStack {
            Image(uiImage: photoItem.image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
                .cornerRadius(12)
                .padding()

            Text("Rating: \(photoItem.rating)/10")
                .font(.headline)
                .padding(.bottom, 10)

            Slider(value: Binding(
                get: {
                    Double(photoItem.rating)
                },
                set: { newValue in
                    photoItem.rating = Int(newValue)
                    photoCollection.updateRating(for: photoItem, rating: Int(newValue))
                }
            ), in: 0...10, step: 1)
            .padding([.leading, .trailing], 20)

            Spacer()
        }
    }
}
