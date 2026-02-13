import Foundation

public protocol MediasUseCaseProtocol: Sendable {
    func getAllMedias() async throws -> [BreedEntity]
}

public struct MediasUseCase: MediasUseCaseProtocol, Sendable {
    private let repository: any MediasRepositoryProtocol & Sendable

    public init(repository: any MediasRepositoryProtocol & Sendable) {
        self.repository = repository
    }

    public func getAllMedias() async throws -> [BreedEntity] {
        try await repository.getAllMedias()
    }
}
