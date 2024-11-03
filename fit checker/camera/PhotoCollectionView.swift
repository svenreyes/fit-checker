import SwiftUI

struct PhotoCollectionView: View {
    @ObservedObject var photoCollection: PhotoCollection
    @State private var selectedPhoto: UIImage? = nil
    @State private var isShowingDetail = false
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(photoCollection.photos.indices, id: \..self) { index in
                        let photo = photoCollection.photos[index]
                        let rating = photoCollection.ratings[index]
                        
                        VStack {
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20)
                                .clipped()
                                .cornerRadius(12)
                                .onTapGesture {
                                    selectedPhoto = photo
                                    withAnimation(.easeInOut) {
                                        isShowingDetail = true
                                    }
                                }
                            Text("Rating: \(rating)/10")
                                .font(.caption)
                                .padding(.top, -0.5)
                                .bold()
                        }
                    }
                }
                .padding(5)
            }
            .navigationTitle("Gallery")
            
            if let selectedPhoto = selectedPhoto, isShowingDetail {
                VStack {
                    Spacer()
                    PhotoDetailView(photo: selectedPhoto, rating: photoCollection.ratings[photoCollection.photos.firstIndex(of: selectedPhoto)!])
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isShowingDetail)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.height > 100 {
                                        withAnimation {
                                            isShowingDetail = false
                                        }
                                    }
                                }
                        )
                }
                .background(
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isShowingDetail = false
                            }
                        }
                )
            }
        }
    }
}

struct PhotoCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        let photoCollection = PhotoCollection()
        NavigationView {
            PhotoCollectionView(photoCollection: photoCollection)
        }
    }
}
