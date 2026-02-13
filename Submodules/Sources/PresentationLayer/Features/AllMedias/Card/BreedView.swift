import SwiftUI
import DomainLayer
import PresentationLayer_DesignSystem

public struct BreedView: View { //TODO: rename file and folder
    var viewModel: BreedViewModel
    private let tileWidth: CGFloat
    private let tileHeight: CGFloat
    
    public init(viewModel: BreedViewModel) {
        self.viewModel = viewModel
        self.tileWidth = 120
        self.tileHeight = 170
    }
    
    public init(viewModel: BreedViewModel, tileWidth: CGFloat, tileHeight: CGFloat) {
        self.viewModel = viewModel
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.98, green: 0.52, blue: 0.17), Color(red: 0.20, green: 0.27, blue: 0.43)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.45)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        Text(String(viewModel.title.prefix(1)))
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.25))
                            .padding(10),
                        alignment: .topLeading
                    )
                
                Text(viewModel.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .padding(10)
            }
            .frame(width: tileWidth, height: tileHeight)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundStyle(Color(red: 0.58, green: 0.75, blue: 0.89))
                Text(viewModel.ratingText)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .padding(.leading, 2)
        }
        .frame(width: tileWidth, alignment: .leading)
        .shadow(color: .black.opacity(0.28), radius: 10, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(viewModel.title), rating \(viewModel.ratingText)")
    }
}

struct BreedView_Preview: PreviewProvider {
    static var previews: some View {
        let breedMock = BreedEntity.mock.first
        let viewModel = BreedViewModel(breed: breedMock!)
        
        return BreedView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}
