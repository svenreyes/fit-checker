/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct CameraView: View {
    @StateObject private var model = DataModel()
    
    private static let barHeightFactor = 0.15
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image: $model.viewfinderImage)
                    // Top overlay with the "Switch Camera" button on the top-right
                    .overlay(alignment: .top) {
                        HStack {
                            Spacer()
                            
                            Button {
                                model.camera.switchCaptureDevice()
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.orange)
                            }
                            .padding()
                        }
                        .frame(height: geometry.size.height * Self.barHeightFactor)
                        .background(Color.black.opacity(0.75))
                    }
                    // Bottom overlay with the buttons view
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(Color.black.opacity(0.75))
                    }
                    .overlay(alignment: .center) {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(Color.black)
            }
            .task {
                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func buttonsView() -> some View {
        ZStack {
            // Centered "Take Photo" button
            Button {
                model.camera.takePhoto()
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(Color.orange, lineWidth: 7)
                        .frame(width: 62, height: 62)
                }
            }
            .accessibilityLabel("Take Photo")
        
        }
        .padding()
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
    }
}
