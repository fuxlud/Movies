import Foundation
import DomainLayer
import InfrastructureLayer

public extension WebService {
    func getAllMedias() async throws -> [BreedDTO] {
        let request = BreedRequest()

        let result = try await request.execute(on: router)

        if let mediasContainer = result as? MediasResponseDTO {
            let medias = mediasContainer.medias.medias.sorted{ $0.name < $1.name }
            return medias
        } else {
            throw APIError.notFound
        }
    }
}

struct BreedRequest: RequestTypeProtocol {
    typealias ResponseType = MediasResponseDTO

    var request: Request {
        var components = URLComponents()
        components.scheme = NetworkScheme.https.rawValue
        components.host = NetworkHost.dogs.rawValue
        components.path = EndPoint.allMedias.rawValue
        let path = components.url?.absoluteString ?? ""

        return Request(path: path, method: .get)
    }
}
