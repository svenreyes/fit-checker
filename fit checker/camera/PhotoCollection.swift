import SwiftUI
import os.log

final class PhotoCollection: ObservableObject {
    // Stores photos taken in-app
    @Published var photos: [UIImage] = []
    
    private let logger = Logger(subsystem: "com.app.photocollection", category: "PhotoCollection")
    
    // Add a photo to the collection
    func addPhoto(_ photo: UIImage) {
        photos.append(photo)
        logger.debug("Added new photo to collection.")
    }
    
    // Remove a specific photo from the collection
    func removePhoto(at index: Int) {
        guard photos.indices.contains(index) else { return }
        photos.remove(at: index)
        logger.debug("Removed photo at index \(index).")
    }
    
    // Clear all photos in the collection
    func clearPhotos() {
        photos.removeAll()
        logger.debug("Cleared all photos from collection.")
    }
}
