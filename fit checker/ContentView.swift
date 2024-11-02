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
                    .offset(x: offsetFor(viewType: .photoCollection, geometry: geometry) + dragOffset)
                    .zIndex(currentView == .photoCollection ? 1 : 0)

                // Main Camera View (center)
                CameraView()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: geometry.size.width)
                    .offset(x: offsetFor(viewType: .camera, geometry: geometry) + dragOffset)
                    .zIndex(currentView == .camera ? 1 : 0)

                // Community View (right side)
                CommunityView()
                    .frame(maxWidth: geometry.size.width)
                    .offset(x: offsetFor(viewType: .community, geometry: geometry) + dragOffset)
                    .zIndex(currentView == .community ? 1 : 0)
            }
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.width
                    }
                    .onEnded { value in
                        let dragThreshold: CGFloat = 100

                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            if value.translation.width < -dragThreshold {
                                // Swipe left
                                if currentView == .camera {
                                    currentView = .community
                                } else if currentView == .photoCollection {
                                    currentView = .camera
                                }
                            } else if value.translation.width > dragThreshold {
                                // Swipe right
                                if currentView == .camera {
                                    currentView = .photoCollection
                                } else if currentView == .community {
                                    currentView = .camera
                                }
                            }
                            dragOffset = 0
                        }
                    }
            )
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
