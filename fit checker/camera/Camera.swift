import AVFoundation
import UIKit
import SwiftUI
import os.log

class Camera: NSObject, ObservableObject {
    private let captureSession = AVCaptureSession()
    private var photoOutput: AVCapturePhotoOutput?
    private let sessionQueue = DispatchQueue(label: "session.queue")
    private let logger = Logger(subsystem: "com.app.camera", category: "Camera")
    
    @Published var capturedImage: UIImage?

    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            defer { self.captureSession.commitConfiguration() }
            
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.captureSession.canAddInput(input) else {
                self.logger.error("Failed to set up capture session input.")
                return
            }
            
            self.captureSession.addInput(input)
            
            let output = AVCapturePhotoOutput()
            guard self.captureSession.canAddOutput(output) else {
                self.logger.error("Failed to add photo output to session.")
                return
            }
            
            self.captureSession.addOutput(output)
            self.photoOutput = output
        }
    }
    
    func startSession() {
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func takePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// Extension for Camera to conform to AVCapturePhotoCaptureDelegate
extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let imageData = photo.fileDataRepresentation() else {
            logger.error("Error capturing photo: \(error?.localizedDescription ?? "unknown error")")
            return
        }
        
        self.capturedImage = UIImage(data: imageData)
    }
}
