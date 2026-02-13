import SwiftUI
import PresentationLayer_DesignSystem

public struct HomeView: View {
    @State private var searchText = "" //TODO: remove from here
    var viewModel: HomeViewModel
    let spacing: CGFloat = 70

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ZStack {
                AppBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: spacing) {
                        showsView

                        moviesView
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    SearchBarControlsView(
                        searchText: $searchText,
                        favoriteCount: viewModel.favoriteCount
                    )
                    .padding(.bottom, 8)
                }
            }
        }
    }

    var showsView: some View {
        let railViewModel = MediaShelfViewModel(
            type: .shows,
            mediasUseCase: viewModel.mediasUseCase,
            mediaDetailsUseCase: viewModel.mediaDetailsUseCase,
            favoritesUseCase: viewModel.favoritesUseCase,
            favoritingUseCase: viewModel.favoritingUseCase
        )
        return MediaShelfView(viewModel: railViewModel)
    }

    var moviesView: some View {
        let railViewModel = MediaShelfViewModel(
            type: .movies,
            mediasUseCase: viewModel.mediasUseCase,
            mediaDetailsUseCase: viewModel.mediaDetailsUseCase,
            favoritesUseCase: viewModel.favoritesUseCase,
            favoritingUseCase: viewModel.favoritingUseCase
        )
        return MediaShelfView(viewModel: railViewModel)
    }
}
