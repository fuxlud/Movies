import SwiftUI
import DomainLayer
import DataLayer
import InfrastructureLayer
import PresentationLayer_Features_AllMedias
import PresentationLayer_Features_DetailsScreen
import PresentationLayer_Features_FavoritesScreen

public struct MainTabBar: View {
    
    private let dependencies: AppDependencies
    
    public init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    public var body: some View {
        TabView {
            homeView
                .tabItem {
                    Label("Home", systemImage: "popcorn")
                }

            favorites
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
    
    var homeView: some View {
        let viewModel = HomeViewModel(
            mediasUseCase: dependencies.mediasUseCase,
            mediaDetailsUseCase: dependencies.mediaDetailsUseCase,
            favoritesUseCase: dependencies.favoritesUseCase,
            favoritingUseCase: dependencies.favoritingUseCase
        )
        return HomeView(viewModel: viewModel)
    }
    
    var favorites: some View {

        let viewModel = FavoritesViewModel(
            favoritesUseCase: dependencies.favoritesUseCase,
            favoritingUseCase: dependencies.favoritingUseCase
        )
        return FavoritesView(viewModel: viewModel)
    }
}
