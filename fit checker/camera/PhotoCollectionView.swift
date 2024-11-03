import Foundation
import SwiftUI

struct PhotoCollectionView: View {
    @ObservedObject var photoCollection: PhotoCollection
    @State private var selectedPhotoItem: PhotoItem? = nil
    @State private var isShowingDetail = false
    private var dateString: String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: currentDate)
    }

    var body: some View {
        ZStack {
            VStack {
                Text("Gallery")
                    .font(.title).bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center) // Center the text at the top
                    .background(Color.black) // Add a background if needed to differentiate

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(photoCollection.items) { item in
                            VStack {
                                Image(uiImage: item.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20)
                                    .clipped()
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedPhotoItem = item
                                        withAnimation(.easeInOut) {
                                            isShowingDetail = true
                                        }
                                    }
                                Text((dateString))
                                    .font(.caption)
                                    .padding(.top, -0.5)
                                    .bold()
                            }
                        }
                    }
                    .padding(5)
                }
                .navigationTitle("Gallery")
            }

            if let selectedPhotoItem = selectedPhotoItem, isShowingDetail {
                VStack {
                    Spacer()
                    PhotoDetailView(photoItem: selectedPhotoItem, photoCollection: photoCollection)
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
