import SwiftUI

struct ContentView: View {
    @State private var currentView: ViewType = .camera
    @StateObject private var model = DataModel()
    @State private var dragOffset: CGFloat = 0
    
    enum ViewType {
        case camera
        case community
        case photoCollection
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Photo Collection View (left side)
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .frame(maxWidth: geometry.size.width)
                    .offset(x: offsetFor(viewType: .photoCollection, geometry: geometry))
                    .zIndex(currentView == .photoCollection ? 1 : 0)
                
                // Main Camera View (center)
                CameraView()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: geometry.size.width)
                    .offset(x: offsetFor(viewType: .camera, geometry: geometry))
                    .zIndex(currentView == .camera ? 1 : 0)
                
                // Community View (right side)
                CommunityView()
                    .frame(maxWidth: geometry.size.width)
                    .offset(x: offsetFor(viewType: .community, geometry: geometry))
                    .zIndex(currentView == .community ? 1 : 0)
            }
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.width
                    }
                    .onEnded { value in
                        let dragThreshold: CGFloat = 100
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if value.translation.width < -dragThreshold && currentView != .community {
                                currentView = .community
                            } else if value.translation.width > dragThreshold && currentView != .photoCollection {
                                currentView = .photoCollection
                            }
                            dragOffset = 0
                        }
                    }
            )
            
            // Back buttons
            if currentView != .camera {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                currentView = .camera
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color.black.opacity(0.5)))
                        }
                        .padding(.leading)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .environmentObject(model)
    }
    
    private func offsetFor(viewType: ViewType, geometry: GeometryProxy) -> CGFloat {
        let screenWidth = geometry.size.width
        
        switch (viewType, currentView) {
        case (.camera, .camera):
            return 0
        case (.camera, .photoCollection):
            return screenWidth
        case (.camera, .community):
            return -screenWidth
        case (.photoCollection, .camera):
            return -screenWidth
        case (.photoCollection, .photoCollection):
            return 0
        case (.photoCollection, .community):
            return -2 * screenWidth
        case (.community, .camera):
            return screenWidth
        case (.community, .photoCollection):
            return 2 * screenWidth
        case (.community, .community):
            return 0
        }
    }
}

#Preview {
    ContentView()
}
