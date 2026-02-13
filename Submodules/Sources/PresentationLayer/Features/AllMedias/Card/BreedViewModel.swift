import Foundation
import DomainLayer

@Observable
public class BreedViewModel: Identifiable {
    public let id: UUID
    public let title: String
    private let rating: Double?
    public let posterURL: URL?

    public init(breed: BreedEntity) {
        self.id = UUID()
        self.title = breed.name.capitalized(with: .current)
        self.rating = nil
        self.posterURL = nil
    }

    public init(title: String, rating: Double?, posterURL: URL?) {
        self.id = UUID()
        self.title = title
        self.rating = rating
        self.posterURL = posterURL
    }

    public var ratingText: String {
        if let rating {
            return String(format: "%.1f", rating)
        }
        return String(format: "%.1f", calculatedRating)
    }

    private var calculatedRating: Double {
        let hash = abs(title.hashValue % 6)
        return 4.3 + (Double(hash) * 0.1)
    }
}

extension BreedViewModel: Equatable {
    public static func == (lhs: BreedViewModel, rhs: BreedViewModel) -> Bool {
      return lhs.id == rhs.id
    }
}
