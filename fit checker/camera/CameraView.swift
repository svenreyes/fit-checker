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
                    HStack {
                        Spacer()
                        Button(action: {
                            camera.flipCamera()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .frame(width: 50, height: 40)
                                .padding(15) // Added more padding here
                                .clipShape(Circle())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 20) // Additional top padding
                        .padding(.trailing, 25) // Increased right padding
                    }
                    Spacer()
                    
                    HStack {
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
                        Spacer()
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
