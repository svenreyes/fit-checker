import SwiftUI

struct PhotoCollectionView: View {
    @ObservedObject var photoCollection: PhotoCollection

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(photoCollection.photos, id: \.self) { photo in
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20)
                        .clipped()
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Gallery")
    }
}

struct PhotoCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        let photoCollection = PhotoCollection()
        PhotoCollectionView(photoCollection: photoCollection)
    }
    
}
