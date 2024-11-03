import SwiftUI

struct CameraView: View {
    @StateObject private var camera = Camera()
    @ObservedObject var photoCollection: PhotoCollection

    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                if let image = camera.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                VStack {
                    Spacer()
                    
                    Button(action: {
                        camera.takePhoto()
                    }) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color.orange, lineWidth: 7)
                                .frame(width: 70, height: 70)
                        }
                    }
                    .padding(.bottom, 20)
                    .onChange(of: camera.capturedImage) { newImage in
                        if let newImage = newImage {
                            photoCollection.addPhoto(newImage)
                        }
                    }
                }
            }
            .onAppear {
                camera.startSession()
            }
            .onDisappear {
                camera.stopSession()
            }
        }
    }
}
