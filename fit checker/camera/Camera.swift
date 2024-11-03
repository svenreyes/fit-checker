import AVFoundation
import UIKit
import SwiftUI
import os.log

class Camera: NSObject, ObservableObject {
    let captureSession = AVCaptureSession()
    private var photoOutput: AVCapturePhotoOutput?
    private let sessionQueue = DispatchQueue(label: "session.queue")
    private let logger = Logger(subsystem: "com.app.camera", category: "Camera")
    
    @Published var capturedImage: UIImage?
    private var currentDevicePosition: AVCaptureDevice.Position = .back

    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            defer { self.captureSession.commitConfiguration() }
            
            self.addInput(for: self.currentDevicePosition)
            
            let output = AVCapturePhotoOutput()
            guard self.captureSession.canAddOutput(output) else {
                self.logger.error("Failed to add photo output to session.")
                return
            }
            
            self.captureSession.addOutput(output)
            self.photoOutput = output
        }
    }
    
    private func addInput(for position: AVCaptureDevice.Position) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: device) else {
            logger.error("Failed to set up capture session input.")
            return
        }

        if let existingInput = self.captureSession.inputs.first as? AVCaptureDeviceInput,
           existingInput.device.position == position {
            return
        }

        self.captureSession.inputs.forEach { self.captureSession.removeInput($0) }
        
        guard self.captureSession.canAddInput(input) else {
            logger.error("Cannot add capture session input.")
            return
        }
        
        self.captureSession.addInput(input)
    }

    func startSession() {
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.logger.debug("Capture session started successfully.")
                }
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
        guard let photoOutput = photoOutput, captureSession.isRunning else {
            logger.error("Capture session is not running or photo output is unavailable.")
            return
        }
        
        guard let connection = photoOutput.connection(with: .video), connection.isEnabled, connection.isActive else {
            logger.error("No active and enabled video connection.")
            return
        }

        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func flipCamera() {
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                self.logger.debug("Capture session stopped for flipping camera.")
            }
            
            self.captureSession.beginConfiguration()
            
            self.currentDevicePosition = self.currentDevicePosition == .back ? .front : .back
            self.addInput(for: self.currentDevicePosition)
            
            self.captureSession.commitConfiguration()
            self.logger.debug("Capture session configuration committed for flipped camera.")
            
            self.captureSession.startRunning()
            self.logger.debug("Capture session restarted after flipping camera.")
        }
    }
}

func requestCameraPermission(completion: @escaping (Bool) -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        completion(true)
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    default:
        completion(false)
    }
}



extension Camera: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            logger.error("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            logger.error("No image data representation.")
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = UIImage(data: imageData)
        }
    }
}
