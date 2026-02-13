import Foundation
import DomainLayer
import InfrastructureLayer

public struct MediasRepository: MediasRepositoryProtocol, Sendable {
    
    private let service: WebService

    public init(service: WebService) {
        self.service = service
    }
    
    public func getAllMedias() async throws -> [BreedEntity] {
        let dto: [BreedDTO] = try await service.getAllMedias()
        return dto.map { $0.toBreedEntity() }
    }
}
