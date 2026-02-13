import Foundation
import DomainLayer

@Observable 
public class BreedViewModel: Identifiable {
    private let breed: BreedEntity?
    public let id: UUID
    private let customTitle: String?
    private let customRating: Double?
    
    public init(breed: BreedEntity) {
        self.breed = breed
        self.id = UUID()
        self.customTitle = nil
        self.customRating = nil
    }
    
    public init(title: String, rating: Double?) {
        self.breed = nil
        self.id = UUID()
        self.customTitle = title
        self.customRating = rating
    }
    
    public var title: String {
        if let customTitle {
            return customTitle
        }
        return breed?.name.capitalized(with: .current) ?? ""
    }
    
    public var ratingText: String {
        if let customRating {
            return String(format: "%.1f", customRating)
        }
        return String(format: "%.1f", calculatedRating)
    }
    
    private var calculatedRating: Double {
        let hash = abs((breed?.name.hashValue ?? 0) % 6)
        return 4.3 + (Double(hash) * 0.1)
    }
}

extension BreedViewModel: Equatable {
    public static func == (lhs: BreedViewModel, rhs: BreedViewModel) -> Bool {
      return lhs.id == rhs.id
    }
}
