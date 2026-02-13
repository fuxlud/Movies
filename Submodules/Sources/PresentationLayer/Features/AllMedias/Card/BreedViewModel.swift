import Foundation
import DomainLayer

@Observable 
public class BreedViewModel: Identifiable {
    private let breed: BreedEntity
    public let id = UUID()
    
    public init(breed: BreedEntity) {
        self.breed = breed
    }
    
    public var title: String {
        breed.name.capitalized(with: .current)
    }
    
    public var ratingText: String {
        String(format: "%.1f", calculatedRating)
    }
    
    private var calculatedRating: Double {
        let hash = abs(breed.name.hashValue % 6)
        return 4.3 + (Double(hash) * 0.1)
    }
}

extension BreedViewModel: Equatable {
    public static func == (lhs: BreedViewModel, rhs: BreedViewModel) -> Bool {
      return lhs.id == rhs.id
    }
}
