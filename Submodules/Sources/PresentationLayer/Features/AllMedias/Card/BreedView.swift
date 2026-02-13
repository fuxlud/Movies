import SwiftUI
import DomainLayer
import PresentationLayer_DesignSystem

public struct BreedView: View { //TODO: rename file and folder
    var viewModel: BreedViewModel
    private let tileWidth: CGFloat
    private let tileHeight: CGFloat
    
    private let cornerRadius: CGFloat = 14

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
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let posterURL = viewModel.posterURL {
                    URLImage(posterURL)
                        .frame(width: tileWidth, height: tileHeight)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.accentColor)
                }
            }
            .frame(width: tileWidth, height: tileHeight)

            Text(viewModel.title)
                .font(.headline.weight(.semibold))
//                .lineLimit(1)
                .foregroundStyle(.white)
                .padding(.leading, 2)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.footnote) //TODO: verify large fonts
                    .foregroundStyle(Color(red: 0.58, green: 0.75, blue: 0.89))
                Text(viewModel.ratingText)
                    .font(.subheadline)
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
