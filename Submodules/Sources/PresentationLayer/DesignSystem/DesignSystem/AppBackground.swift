import SwiftUI

public struct AppBackground: View {
    public init() {}
    
    public var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.15, blue: 0.24),
                Color(red: 0.05, green: 0.09, blue: 0.14),
                Color.black.opacity(0.94)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
