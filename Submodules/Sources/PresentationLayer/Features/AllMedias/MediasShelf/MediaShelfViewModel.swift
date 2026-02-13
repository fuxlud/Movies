import Foundation
import DomainLayer
import DataLayer
import InfrastructureLayer
import PresentationLayer_Features_DetailsScreen

@MainActor
@Observable
class MediaShelfViewModel {
    enum RailType {
        case shows
        case movies
    }

    let type: RailType
    var state: ViewState<[BreedViewModel]> = .idle(data: [])

    private let mediasUseCase: MediasUseCaseProtocol
    private let mediaDetailsUseCase: BreedDetailsUseCaseProtocol
    private let favoritesUseCase: FetchFavoritesUseCaseProtocol
    private let favoritingUseCase: FavoritingUseCaseProtocol

    init(
        type: RailType,
        mediasUseCase: MediasUseCaseProtocol,
        mediaDetailsUseCase: BreedDetailsUseCaseProtocol,
        favoritesUseCase: FetchFavoritesUseCaseProtocol,
        favoritingUseCase: FavoritingUseCaseProtocol
    ) {
        self.type = type
        self.mediasUseCase = mediasUseCase
        self.mediaDetailsUseCase = mediaDetailsUseCase
        self.favoritesUseCase = favoritesUseCase
        self.favoritingUseCase = favoritingUseCase
    }

    enum Action {
        case executeOnceOnAppear
    }

    func dispatch(_ action: Action) async {
        switch action {
        case .executeOnceOnAppear:
            await fetchMedias()
        }
    }

    var title: String {
        switch type {
        case .shows: return "Popular TV Shows"
        case .movies: return "Popular Movies"
        }
    }

    var items: [BreedViewModel] {
        state.data ?? []
    }

    func detailsScreenViewModel(for breedViewModel: BreedViewModel) -> BreedImagesViewModel {
        let breedName = breedViewModel.title.lowercased()
        return BreedImagesViewModel(
            breedName: breedName,
            mediaDetailsUseCase: mediaDetailsUseCase,
            favoritesUseCase: favoritesUseCase,
            favoritingUseCase: favoritingUseCase
        )
    }

    private func fetchMedias() async {
        let candidateKeys = [
            "TMDB_API_KEY",  // preferred //TODO: remove
            "TMBD_API_Key",  // common typo fallback
            "TMDB_API_Key"   // casing fallback
        ]
        
        let apiKey = candidateKeys
            .compactMap { Bundle.main.object(forInfoDictionaryKey: $0) as? String }
            .first { !$0.isEmpty }
        
        guard let apiKey else { //TODO: remove
            state = .error(message: "Missing TMDB API key in Info.plist (checked: TMDB_API_KEY, TMBD_API_Key, TMDB_API_Key)")
            return
        }
        
        let webService = WebService()
        
        do {
            let response: TMDBPopularResponseDTO
            switch type {
            case .shows:
                response = try await webService.getPopularShows(apiKey: apiKey)
            case .movies:
                response = try await webService.getPopularMovies(apiKey: apiKey)
            }
            
            let viewModels = response.results.map {
                BreedViewModel(title: $0.title, rating: $0.voteAverage)
            }
            state = .idle(data: viewModels)
        } catch let error as ErrorEntity {
            state = .error(message: error.description)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
