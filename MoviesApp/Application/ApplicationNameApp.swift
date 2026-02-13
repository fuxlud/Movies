import SwiftUI
import PresentationLayer_Features_AllMedias
import DataLayer

@main

struct ApplicationNameApp: App {
    
    private let dependencies: AppDependencies
    
    init() {
        DIContainerRegistration.registerComponents()
        self.dependencies = AppDependencies.resolve()
    }
    
    var body: some Scene {
        WindowGroup {
            homeView
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
}
