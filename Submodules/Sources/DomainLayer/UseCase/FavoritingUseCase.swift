import Foundation

public protocol FavoritingUseCaseProtocol: Sendable {
    func toggleLiking(mediaDetailsEntity: BreedDetailsEntity)
}

public struct FavoritingUseCase: FavoritingUseCaseProtocol, Sendable {
    private let repository: any BreedDetailsRepositoryProtocol & Sendable

    public init(repository: any BreedDetailsRepositoryProtocol & Sendable) {
        self.repository = repository
    }
    
    public func toggleLiking(mediaDetailsEntity: BreedDetailsEntity) {
        repository.toggleLiking(mediaDetailsEntity: mediaDetailsEntity)
    }
}
