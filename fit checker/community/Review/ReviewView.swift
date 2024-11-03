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
    
    private func fetchFeedbackForOutfit() {
        guard let base64Image = image.resizedAndCompressedBase64(targetSize: CGSize(width: 768, height: 768), compressionQuality: 0.5) else {
            print("Image conversion to base64 failed.")
            feedback = "Image conversion failed."
            return
        }

        // Call fetchOutfitFeedback, the correct method from OpenAIService
        openAIService.fetchOutfitFeedback(base64Image: base64Image) { response in
            DispatchQueue.main.async {
                feedback = response ?? "Could not fetch feedback. Please try again."
            }
        }
    }
    
    // Function to call OpenAIService for feedback with GPT-4 Vision capabilities
//    private func fetchFeedbackForOutfit() {
//        guard let base64Image = image.resizedAndCompressedBase64(targetSize: CGSize(width: 768, height: 768), compressionQuality: 0.5) else {
//            print("Image conversion to base64 failed.")
//            feedback = "Image conversion failed."
//            return
//        }
//
//        // Set up the prompt with image content
//        let prompt: [[String: Any]] = [
//            [
//                "role": "user",
//                "content": [
//                    ["type": "text", "text": "Please provide an analysis of this outfit, including its style, color scheme, and trendiness."],
//                    [
//                        "type": "image_url",
//                        "image_url": [
//                            "url": "data:image/jpeg;base64,\(base64Image)",
//                            "detail": "high"  // Specify 'high' for detailed analysis or 'low' for faster processing with lower detail
//                        ]
//                    ]
//                ]
//            ]
//        ]
//
//        openAIService.fetchOutfitFeedbackWithImage(prompt: prompt) { response in
//            DispatchQueue.main.async {
//                feedback = response ?? "Could not fetch feedback. Please try again."
//            }
//        }
//    }
}

// UIImage extension for resizing and compressing the image before base64 encoding
extension UIImage {
    func resizedAndCompressedBase64(targetSize: CGSize, compressionQuality: CGFloat) -> String? {
        let resizedImage = self.resized(to: targetSize)
        guard let compressedData = resizedImage.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        return compressedData.base64EncodedString(options: .lineLength64Characters)
    }
    
    private func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = CGSize(width: size.width * min(widthRatio, heightRatio), height: size.height * min(widthRatio, heightRatio))
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}

#Preview {
    ReviewView(image: UIImage(named: "donnyg") ?? UIImage())
}
