import Foundation
import SwiftUI

struct PhotoItem: Identifiable {
    let id = UUID()
    let image: UIImage
    var rating: Int
}

class PhotoCollection: ObservableObject {
    @Published var items: [PhotoItem] = []

    func addPhoto(_ photo: UIImage, rating: Int = 0) {
        let newItem = PhotoItem(image: photo, rating: rating)
        items.append(newItem)
    }

    func updateRating(for item: PhotoItem, rating: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].rating = rating
        }
    }
}
