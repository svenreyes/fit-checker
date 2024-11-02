//
//  CommunityView.swift
//  fit checker
//

import SwiftUI

struct CommunityView: View {
    var isLoaded = true
    
    var body: some View {
        VStack {
            Text("Community")
                .font(.headline)
                .padding(.top, 20)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CommunityView()
}
