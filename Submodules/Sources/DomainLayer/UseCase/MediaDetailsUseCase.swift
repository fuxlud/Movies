import Foundation

public protocol BreedDetailsUseCaseProtocol: Sendable {
    func getBreedDetails(breedName: String) async throws -> [BreedDetailsEntity]
}

public struct BreedDetailsUseCase: BreedDetailsUseCaseProtocol, Sendable {
    private let repository: any BreedDetailsRepositoryProtocol & Sendable
    
    public init(repository: any BreedDetailsRepositoryProtocol & Sendable) {
        self.repository = repository
    }
    
    public func getBreedDetails(breedName: String) async throws -> [BreedDetailsEntity] {
        async let mediaDetailsTask = repository.getRemoteBreedDetails(breedName: breedName)
        async let favoritesTask = repository.fetchFavorites()
        
        var mediaDetails = try await mediaDetailsTask
        let favorites = await favoritesTask
        
        for i in 0..<mediaDetails.count {
            if favorites.contains(mediaDetails[i]) {
                mediaDetails[i].isFavorite = true
            }
        }
        return mediaDetails
    }
}
