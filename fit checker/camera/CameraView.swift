import SwiftUI

struct CameraView: View {
    @StateObject private var camera = Camera()
    @ObservedObject var photoCollection: PhotoCollection

    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                CameraPreview(camera: camera)
                                .ignoresSafeArea()

                
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            camera.flipCamera()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .frame(width: 50, height: 40)
                                .padding(15)
                                .clipShape(Circle())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 25)
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
