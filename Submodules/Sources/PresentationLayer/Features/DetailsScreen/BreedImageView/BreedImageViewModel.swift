import Foundation
import DomainLayer
import DataLayer

@Observable 
public class BreedImageViewModel: Identifiable {
    var mediaDetails: BreedDetailsEntity
    private var favoritingUseCase: FavoritingUseCaseProtocol
    public let id = UUID()
    
    public init(mediaDetails: BreedDetailsEntity,
                favoritingUseCase: FavoritingUseCaseProtocol) {
        self.mediaDetails = mediaDetails
        self.favoritingUseCase = favoritingUseCase
    }
    
    var imageUrl: URL? {
        mediaDetails.url
    }
    
    public var title: String {
        let slug = mediaDetails.url.lastPathComponent
        let cleanSlug = slug.replacingOccurrences(of: ".jpg", with: "")
        let parts = cleanSlug
            .split(separator: "-")
            .prefix(2)
            .map { String($0).capitalized }
        if parts.isEmpty {
            return "Untitled"
        }
        return parts.joined(separator: " ")
    }
    
    var ratingText: String {
        String(format: "%.1f", calculatedRating)
    }
    
    private var calculatedRating: Double {
        let hash = abs(mediaDetails.url.absoluteString.hashValue % 7)
        return 4.3 + (Double(hash) * 0.1)
    }
    
    var isFavorite: Bool {
        return mediaDetails.isFavorite
    }
    
    func likeButtonTapped() {
        mediaDetails.isFavorite.toggle()
        favoritingUseCase.toggleLiking(mediaDetailsEntity: mediaDetails)
    }
}

extension BreedImageViewModel: Equatable {
    public static func == (lhs: BreedImageViewModel, rhs: BreedImageViewModel) -> Bool {
      return lhs.id == rhs.id
    }
}
