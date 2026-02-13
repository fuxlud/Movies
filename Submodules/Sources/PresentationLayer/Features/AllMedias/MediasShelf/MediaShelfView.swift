import SwiftUI
import PresentationLayer_DesignSystem
import PresentationLayer_Features_DetailsScreen

struct MediaShelfView: View {
    @State var viewModel: MediaShelfViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white.opacity(0.95))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)

            GeometryReader { proxy in
                let spacing: CGFloat = 10
                let tileWidth = (proxy.size.width - (spacing * 2)) / 3
                let tileHeight = tileWidth * 1.36

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(viewModel.items) { breedViewModel in
                            NavigationLink(
                                destination: BreedImagesScreen(viewModel: viewModel.detailsScreenViewModel(for: breedViewModel)),
                                label: {
                                    BreedView(viewModel: breedViewModel, tileWidth: tileWidth, tileHeight: tileHeight)
                                }
                            )
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            .frame(height: 210)
        }
        .alert(isPresented: .constant(viewModel.state.error != nil)) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.state.error ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
        .executeOnceOnAppear {
            Task {
                await viewModel.dispatch(.executeOnceOnAppear)
            }
        }
    }
}
