import SwiftUI
import AVFoundation

final class DataModel: ObservableObject {
    @Published var capturedPhotos: [UIImage] = []
    private var camera: Camera
    
    init(camera: Camera) {
        self.camera = camera
        setupPhotoCaptureObserver()
    }
    
    private func setupPhotoCaptureObserver() {
        camera.$capturedImage
            .compactMap { $0 }  // Ensure the image is non-nil
            .sink { [weak self] newImage in
                self?.capturedPhotos.append(newImage)
            }
            .store(in: &cancellables)
    }
    
    func takePhoto() {
        camera.takePhoto()
    }
    
}
