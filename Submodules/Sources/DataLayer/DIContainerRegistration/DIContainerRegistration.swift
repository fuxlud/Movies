import DomainLayer
import InfrastructureLayer

@MainActor
public struct DIContainerRegistration {
  
  public static func registerComponents() {
    let container = DIContainer.shared
    let webService = WebService()
    let favoritesManager = FavoritesManager.shared
    let mediaDetailsRepository = BreedDetailsRepository(service: webService, favoritesManager: favoritesManager)
    
    container.register(type: MediasUseCaseProtocol.self, component: MediasUseCase(repository: MediasRepository(service: webService)))
    container.register(type: FetchFavoritesUseCaseProtocol.self, component: FetchFavoritesUseCase(repository: mediaDetailsRepository))
    container.register(type: FavoritingUseCaseProtocol.self, component: FavoritingUseCase(repository: mediaDetailsRepository))
    container.register(type: BreedDetailsUseCaseProtocol.self, component: BreedDetailsUseCase(repository: mediaDetailsRepository))
  }
}
