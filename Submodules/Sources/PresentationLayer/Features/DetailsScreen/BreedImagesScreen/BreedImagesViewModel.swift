import Foundation
import DomainLayer
import Combine
import InfrastructureLayer

@MainActor
@Observable
public class BreedImagesViewModel {
    public let id = UUID()
    public var state: ViewState<[BreedImageViewModel]> = .idle(data: [])

    private var breedName: String
    private let mediaDetailsUseCase: BreedDetailsUseCaseProtocol
    private let favoritesUseCase: FetchFavoritesUseCaseProtocol
    private let favoritingUseCase: FavoritingUseCaseProtocol

    var items: [BreedImageViewModel] = []
    private var cancellables = Set<AnyCancellable>()

    public init(breedName: String,
                mediaDetailsUseCase: BreedDetailsUseCaseProtocol,
                favoritesUseCase: FetchFavoritesUseCaseProtocol,
                favoritingUseCase: FavoritingUseCaseProtocol) {
        self.breedName = breedName
        self.mediaDetailsUseCase = mediaDetailsUseCase
        self.favoritesUseCase = favoritesUseCase
        self.favoritingUseCase = favoritingUseCase
        subscribeToUpdates()
    }
    
    public enum Action {
        case onAppear
    }
    
    public func dispatch(_ action: Action) async {
        switch action {
        case .onAppear:
            await fetchBreedDetails()
        }
    }
    
    internal var title: String {
        breedName.capitalized(with: Locale.current)
    }
   
    private func subscribeToUpdates() {
        favoritesUseCase.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                Task {
                    await self?.updateViewModels(with: items)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    private func updateViewModels(with mediaDetails: [BreedDetailsEntity]) async {
        
        switch state {
        case .idle(let data):
            for viewModelItem in data {
                
                if mediaDetails.first(where: { $0.url == viewModelItem.imageUrl }) != nil
                {
                    if !viewModelItem.mediaDetails.isFavorite {
                        viewModelItem.mediaDetails.isFavorite = true
                    }
                } else {
                    if viewModelItem.mediaDetails.isFavorite {
                        viewModelItem.mediaDetails.isFavorite = false
                    }
                }
            }
            state = .idle(data: data)
        default:
            ()
        }
    }
    
    func fetchBreedDetails() async {
        do {
            let mediaDetails = try await fetchBreedDetailsRemote()
            fillBreedDetails(mediaDetails)
        } catch let error {
            handleError(error)
        }
    }
    
    func fetchBreedDetailsRemote() async throws -> [BreedDetailsEntity] {
        return try await mediaDetailsUseCase.getBreedDetails(breedName: breedName)
    }
    
    @MainActor
    private func handleLoading(_ isLoading: Bool) {
        if isLoading {
            state = .loading
        } else {
            if let viewModels = state.data {
                state = .idle(data: viewModels)
                items = viewModels
            }
        }
    }
    
    @MainActor
    private func fillBreedDetails(_ mediaDetails: [BreedDetailsEntity]) {
        let detailsCardViewModels = mediaDetails.map {
            BreedImageViewModel(mediaDetails: $0,
                                favoritingUseCase: favoritingUseCase) }
        state = .idle(data: detailsCardViewModels)
        items = detailsCardViewModels
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        guard let error = error as? ErrorEntity else {
            state = .error(message: error.localizedDescription)
            return
        }
        state = .error(message: error.description)
    }
}
