import Foundation
@preconcurrency import Combine

public protocol FavoritesManagerProtocol: Sendable {
    func toggleLiking(mediaDetails: BreedDetailsDTO) async
    func isLiked(mediaDetails: BreedDetailsDTO) async -> Bool
    func fetchFavorites() async -> Set<BreedDetailsDTO>
    var favoriteMediasPublisher: AnyPublisher<Set<BreedDetailsDTO>, Never> { get }
}

public actor FavoritesManager: FavoritesManagerProtocol {
    
    public static let shared = FavoritesManager()
    
    private var favoriteMedias: Set<BreedDetailsDTO> = []
    private let persistence: PersistenceProtocol
    private let favoriteMediasSubject: CurrentValueSubject<Set<BreedDetailsDTO>, Never>
    nonisolated public let favoriteMediasPublisher: AnyPublisher<Set<BreedDetailsDTO>, Never>
    
    public init(persistence: PersistenceProtocol = UserDefaults()) {
        self.persistence = persistence
        self.favoriteMediasSubject = CurrentValueSubject<Set<BreedDetailsDTO>, Never>([])
        self.favoriteMediasPublisher = favoriteMediasSubject.eraseToAnyPublisher()
        Task {
            await loadFavoritesFromPersistence()
        }
    }
    
    public func toggleLiking(mediaDetails: BreedDetailsDTO) async {
        if mediaDetails.isFavorite {
            favoriteMedias.insert(mediaDetails)
        } else {
            favoriteMedias.remove(mediaDetails)
        }
        
        favoriteMediasSubject.send(favoriteMedias)
        updatePersistence()
    }
    
    public func isLiked(mediaDetails: BreedDetailsDTO) async -> Bool {
        return favoriteMedias.contains(mediaDetails)
    }
    
    private func updatePersistence() {
        do {
            let favoriteMediasEncoded = try JSONEncoder().encode(favoriteMedias)
            persistence.set(favoriteMediasEncoded, forKey: String(describing: FavoritesManager.self))
        } catch {}
    }
    
    private func loadFavoritesFromPersistence() async {
        if let favoriteMediasEncoded = persistence.data(forKey: String(describing: FavoritesManager.self)) {
            do {
                let decoder = JSONDecoder()
                favoriteMedias = try decoder.decode(Set<BreedDetailsDTO>.self, from: favoriteMediasEncoded)
                favoriteMediasSubject.send(favoriteMedias)
            } catch {}
        }
    }
    
    public func fetchFavorites() async -> Set<BreedDetailsDTO> {
        return favoriteMedias
    }
}
