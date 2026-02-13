import Combine

public struct FavoritingUseCaseMock: FavoritingUseCaseProtocol {
    var mediaDetailsEntity: BreedDetailsEntity
    
    public init(mediaDetailsEntity: BreedDetailsEntity) {
        self.mediaDetailsEntity = mediaDetailsEntity
    }
    
    public func toggleLiking(mediaDetailsEntity: BreedDetailsEntity) {
        ()
    }
}
