@preconcurrency import Combine

public struct FetchFavoritesUseCaseMock: FetchFavoritesUseCaseProtocol, @unchecked Sendable {
  public var itemsPublisher: AnyPublisher<[BreedDetailsEntity], Never>
  
  let mediaDetails: [BreedDetailsEntity]
  
  public init(mediaDetails: [BreedDetailsEntity]) {
    self.mediaDetails = mediaDetails
    self.itemsPublisher = Just(mediaDetails).eraseToAnyPublisher()
  }
  
  public func fetchFavorites() async -> [BreedDetailsEntity] {
    return mediaDetails
  }
}
