import SwiftUI
import UIKit

struct ReviewView: View {
    private let collapsedOffset: CGFloat = UIScreen.main.bounds.height * 0.4
    private let expandedOffset: CGFloat = UIScreen.main.bounds.height * 0.1
    
    @State private var offsetY: CGFloat
    @GestureState private var dragOffset: CGFloat = 0
    
    let image: UIImage // Using UIImage for direct base64 conversion
    @State private var feedback: String? = "Fetching feedback..."
    
    private let openAIService = OpenAIService() // Instantiate the OpenAI service
    
    init(image: UIImage) {
        self.image = image
        _offsetY = State(initialValue: UIScreen.main.bounds.height * 0.4)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background image view with adjusted offset
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .offset(y: (offsetY + dragOffset - collapsedOffset))
                .animation(.easeOut(duration: 0.3), value: offsetY + dragOffset)

            // Bottom sheet
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray)
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                Divider()
                    .padding(.horizontal)

                // Content in the bottom sheet
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Outfit Analysis")
                            .font(.title2)
                            .bold()

                        // Display the AI-generated feedback
                        Text(feedback ?? "No feedback available.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(60)
            .padding(.horizontal, 65)
            .shadow(radius: 40)
            .offset(y: offsetY + dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        withAnimation {
                            let threshold: CGFloat = 100
                            if value.translation.height < -threshold {
                                offsetY = expandedOffset
                            } else if value.translation.height > threshold {
                                offsetY = collapsedOffset
                            }
                        }
                    }
            )
        }
        .onAppear {
            fetchFeedbackForOutfit()
        }
    }
    
    // Function to call OpenAIService for feedback
    private func fetchFeedbackForOutfit() {
        if let base64Image = image.resizedAndCompressedBase64(targetSize: CGSize(width: 200, height: 200), compressionQuality: 0.5) {
            print("Base64 conversion successful.")
            openAIService.fetchOutfitFeedback(base64Image: base64Image) { response in
                DispatchQueue.main.async {
                    if let response = response {
                        print("Feedback received: \(response)")
                        feedback = response
                    } else {
                        print("No feedback received.")
                        feedback = "Could not fetch feedback. Please try again."
                    }
                }
            }
        } else {
            print("Image conversion to base64 failed.")
            feedback = "Image conversion failed."
        }
    }
}

// UIImage extension for resizing and compressing the image before base64 encoding
extension UIImage {
    func resizedAndCompressedBase64(targetSize: CGSize, compressionQuality: CGFloat) -> String? {
        // Resize the image
        let resizedImage = self.resized(to: targetSize)
        
        // Compress the resized image
        guard let compressedData = resizedImage.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        
        // Convert to base64
        return compressedData.base64EncodedString(options: .lineLength64Characters)
    }
    
    // Helper function to resize the image
    private func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = CGSize(width: size.width * min(widthRatio, heightRatio), height: size.height * min(widthRatio, heightRatio))
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self // Return the resized image or the original if resizing fails
    }
}

#Preview {
    ReviewView(image: UIImage(named: "donnyg") ?? UIImage())
}
