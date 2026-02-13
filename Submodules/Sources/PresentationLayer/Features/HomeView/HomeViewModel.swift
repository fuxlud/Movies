import Foundation
import SwiftUI
import Combine
import DomainLayer
import PresentationLayer_Features_DetailsScreen

@MainActor
@Observable
public class HomeViewModel {
    public let id = UUID()
    public var favoriteCount: Int = 0

    public let mediasUseCase: MediasUseCaseProtocol
    public let mediaDetailsUseCase: BreedDetailsUseCaseProtocol
    public let favoritesUseCase: FetchFavoritesUseCaseProtocol
    public let favoritingUseCase: FavoritingUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(
        mediasUseCase: MediasUseCaseProtocol,
        mediaDetailsUseCase: BreedDetailsUseCaseProtocol,
        favoritesUseCase: FetchFavoritesUseCaseProtocol,
        favoritingUseCase: FavoritingUseCaseProtocol
    ) {
        self.mediasUseCase = mediasUseCase
        self.mediaDetailsUseCase = mediaDetailsUseCase
        self.favoritesUseCase = favoritesUseCase
        self.favoritingUseCase = favoritingUseCase
        subscribeToFavorites()
    }

    private func subscribeToFavorites() {
        favoritesUseCase.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.favoriteCount = items.count
            }
            .store(in: &cancellables)
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
}
