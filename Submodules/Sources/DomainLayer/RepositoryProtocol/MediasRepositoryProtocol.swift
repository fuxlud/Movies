import Foundation

public protocol MediasRepositoryProtocol: Sendable {
    func getAllMedias() async throws -> [BreedEntity]
}
