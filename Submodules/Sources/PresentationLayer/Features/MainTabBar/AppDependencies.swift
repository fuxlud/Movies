import DomainLayer
import InfrastructureLayer

@MainActor
public struct AppDependencies {
    public let mediasUseCase: any MediasUseCaseProtocol
    public let mediaDetailsUseCase: any BreedDetailsUseCaseProtocol
    public let favoritesUseCase: any FetchFavoritesUseCaseProtocol
    public let favoritingUseCase: any FavoritingUseCaseProtocol

    public init(
        mediasUseCase: any MediasUseCaseProtocol,
        mediaDetailsUseCase: any BreedDetailsUseCaseProtocol,
        favoritesUseCase: any FetchFavoritesUseCaseProtocol,
        favoritingUseCase: any FavoritingUseCaseProtocol
    ) {
        self.mediasUseCase = mediasUseCase
        self.mediaDetailsUseCase = mediaDetailsUseCase
        self.favoritesUseCase = favoritesUseCase
        self.favoritingUseCase = favoritingUseCase
    }

    public static func resolve() -> AppDependencies {
        let container = DIContainer.shared
        guard let mediasUseCase = container.resolve(type: MediasUseCaseProtocol.self),
              let mediaDetailsUseCase = container.resolve(type: BreedDetailsUseCaseProtocol.self),
              let favoritesUseCase = container.resolve(type: FetchFavoritesUseCaseProtocol.self),
              let favoritingUseCase = container.resolve(type: FavoritingUseCaseProtocol.self) else {
            fatalError("Failed to resolve app dependencies.")
        }

        return AppDependencies(
            mediasUseCase: mediasUseCase,
            mediaDetailsUseCase: mediaDetailsUseCase,
            favoritesUseCase: favoritesUseCase,
            favoritingUseCase: favoritingUseCase
        )
    }
}
