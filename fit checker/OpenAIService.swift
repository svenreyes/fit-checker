import Foundation

struct Secrets {
    static var openAIAPIKey: String? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["OpenAI_APIKey"] as? String else {
            print("API key not found.")
            return nil
        }
        return key
    }
}

class OpenAIService {
    let apiKey: String?
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    init() {
        self.apiKey = Secrets.openAIAPIKey
    }
    
    func fetchOutfitFeedback(base64Image: String, completion: @escaping (String?) -> Void) {
        guard let apiKey = apiKey else {
            print("API key is missing.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "You are a fashion assistant who analyzes outfits based on style, color scheme, and fit."],
            ["role": "user", "content": "Analyze the outfit in this image for style, color scheme, and fitting. Image data (base64): \(base64Image)"]
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": messages,
            "temperature": 0.7,
            "max_tokens": 150
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let feedback = message["content"] as? String {
                    completion(feedback.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Response parsing error. Full response: \(String(describing: try? JSONSerialization.jsonObject(with: data, options: [])))")
                    completion(nil)
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
