public struct MediasUseCaseMock: MediasUseCaseProtocol {
    
    let medias: [BreedEntity]?
    let error: Error?
    
    public func getAllMedias() async throws -> [BreedEntity] {
        if let error {
            throw error
        }
        return medias ?? []
    }
    
    public init(medias: [BreedEntity]? = nil, error: Error? = nil) {
        self.medias = medias
        self.error = error
    }
}
