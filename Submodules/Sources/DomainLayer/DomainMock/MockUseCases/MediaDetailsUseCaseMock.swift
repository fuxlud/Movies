public struct BreedDetailsUseCaseMock: BreedDetailsUseCaseProtocol {
    let mediaDetails: [BreedDetailsEntity]?
    let error: Error?
    
    public init(mediaDetails: [BreedDetailsEntity]? = nil, error: Error? = nil) {
        self.mediaDetails = mediaDetails
        self.error = error
    }

    public func getBreedDetails(breedName: String) async throws -> [BreedDetailsEntity] {
        if let error {
            throw error
        }
        return mediaDetails ?? []
    }
    
    public func toggleLiking(mediaDetailsEntity: BreedDetailsEntity) {
        ()
    }
}
