import Foundation
import DomainLayer
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
        let allItems = state.data ?? []
        switch type {
        case .shows:
            guard !allItems.isEmpty else { return [] }
            let count = max(allItems.count / 2, 1)
            return Array(allItems.prefix(count))
        case .movies:
            guard allItems.count > 1 else { return allItems }
            let startIndex = max(allItems.count / 2, 1)
            return Array(allItems.dropFirst(startIndex))
        }
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
        do {
            let medias = try await mediasUseCase.getAllMedias()
            state = .idle(data: medias.map { BreedViewModel(breed: $0) })
        } catch let error as ErrorEntity {
            state = .error(message: error.description)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }
}
