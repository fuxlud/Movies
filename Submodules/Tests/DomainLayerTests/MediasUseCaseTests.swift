import Testing
import DomainLayer

struct MediasUseCaseTests { //TODO: change tests
    
    @Test func whenFetchMediasSuccess_shouldReturnMediasList() async {
        let sut = MediasUseCaseMock(medias: BreedEntity.mock)
        
        do {
            let medias = try await sut.getAllMedias()
            
            #expect(medias.count == 10)
            
            if let breed = medias.first {
                #expect(breed.name == "Golden Retriever")
            }
        } catch {}
    }
    
    @Test func whenFetchMediasFailure_shouldReturnMediasError() async {
        let sut = MediasUseCaseMock(error: ErrorEntity.general)
        
        do {
            let _ = try await sut.getAllMedias()
        } catch let error {
            guard let concreteError = error as? ErrorEntity else { return }
            #expect(concreteError == ErrorEntity.general)
        }
    }
}
