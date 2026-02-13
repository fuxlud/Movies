import Testing
import DomainLayer
import PresentationLayer_Features_AllMedias

struct HomeViewModelTests {
    
    @Test func whenMediasFetchedSuccesfully_shouldFillMediasViewModelArray_andShowCorrectInfo() async {
        let sut = await makeSUT(mediasUseCase: MediasUseCaseMock(medias: BreedEntity.mock))
        await sut.dispatch(.executeOnceOnAppear)
        
        #expect(sut.state.data?.count == 10)
        #expect(sut.state.error == nil)
        
        if let breedViewModel = sut.state.data?.first as? BreedEntity {
            #expect(breedViewModel.name == "Golden Retriever")
        }
    }
    
    @Test func whenAstronomiesFetchError_shouldPresentError() async {
        let sut = await makeSUT(mediasUseCase: MediasUseCaseMock(error: ErrorEntity.general))
        
        await sut.dispatch(.executeOnceOnAppear)
        
        #expect(sut.state.error != nil)
        
        if let error = sut.state.error {
            #expect(error == "Oops, something went wrong")
        }
    }
    
    @MainActor
    func makeSUT(mediasUseCase: some MediasUseCaseProtocol) -> HomeViewModel {
        let sut = HomeViewModel(
            mediasUseCase: mediasUseCase,
            mediaDetailsUseCase: BreedDetailsUseCaseMock(),
            favoritesUseCase: FetchFavoritesUseCaseMock(),
            favoritingUseCase: FavoritingUseCaseMock()
        )
        return sut
    }
}
