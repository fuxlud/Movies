import SwiftUI
import PresentationLayer_DesignSystem

struct MediasHeaderView: View {
    @Binding var searchText: String
    let favoriteCount: Int
    
    var body: some View {
        HStack(spacing: 10) {
            GlassSearchField(text: $searchText, placeholder: "Search movies & TV...")
            
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.16), lineWidth: 1)
                    )
                Image(systemName: "heart")
                    .foregroundStyle(Color(red: 0.39, green: 0.65, blue: 0.98))
                    .font(.system(size: 17, weight: .semibold))
            }
            .overlay(alignment: .topTrailing) {
                if favoriteCount > 0 {
                    Text("\(favoriteCount)")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(red: 0.91, green: 0.31, blue: 0.35))
                        .clipShape(Capsule())
                        .offset(x: 7, y: -6)
                }
            }
        }
    }
}
