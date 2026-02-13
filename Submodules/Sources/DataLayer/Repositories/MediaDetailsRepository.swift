@preconcurrency import Combine
import Foundation
import DomainLayer
import InfrastructureLayer

public struct BreedDetailsRepository: BreedDetailsRepositoryProtocol, Sendable {
    private let service: WebService
    private let favoritesManager: FavoritesManagerProtocol
    
    public init(service: WebService, favoritesManager: FavoritesManagerProtocol) {
        self.service = service
        self.favoritesManager = favoritesManager
    }
    
    public func getRemoteBreedDetails(breedName: String) async throws -> [BreedDetailsEntity] {
        let mediaDetailsDTOs: [BreedDetailsDTO] = try await service.getBreedDetails(breedName: breedName)
        return mediaDetailsDTOs.map { $0.toBreedDetailsEntity() }
    }
    
    public func fetchFavorites() async -> Set<BreedDetailsEntity> {
        await Set(favoritesManager.fetchFavorites().map { $0.toBreedDetailsEntity() })
    }
    
    public func toggleLiking(mediaDetailsEntity: BreedDetailsEntity) {
        Task {
            await favoritesManager.toggleLiking(mediaDetails: mediaDetailsEntity.toBreedDetailsDTO())
        }
    }
    
    public var itemsPublisher: AnyPublisher<[BreedDetailsEntity], Never> {
        favoritesManager.favoriteMediasPublisher
            .map { favoriteMedias in
                favoriteMedias.map { $0.toBreedDetailsEntity() }
            }
            .eraseToAnyPublisher()
    }
}
