@preconcurrency import Combine
import Foundation

public protocol BreedDetailsRepositoryProtocol: Sendable {
    func getRemoteBreedDetails(breedName: String) async throws -> [BreedDetailsEntity]
    func toggleLiking(mediaDetailsEntity: BreedDetailsEntity)
    func fetchFavorites() async -> Set<BreedDetailsEntity>
    var itemsPublisher: AnyPublisher<[BreedDetailsEntity], Never> { get }
}
