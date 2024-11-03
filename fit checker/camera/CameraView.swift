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
                                .frame(width: 35, height: 30)
                                .padding(6)
                                .padding(.top, 26)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.brown)
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
                                    .strokeBorder(Color.brown, lineWidth: 7)
                                    .frame(width: 70, height: 70)
                                    .padding(.bottom, 10)
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
            .alert(isPresented: $camera.showFeedbackPopup) {
                Alert(title: Text("Outfit Feedback"), message: Text(camera.outfitFeedback ?? "No feedback available."), dismissButton: .default(Text("OK")))
            }
        }
    }
}
