import Foundation
import InfrastructureLayer

public extension WebService {
    func getPopularShows(
        apiKey: String,
        language: String = "en-US",
        page: Int = 1
    ) async throws -> TMDBPopularResponseDTO {
        let request = PopularShowsRequest(apiKey: apiKey, language: language, page: page)
        let result = try await request.execute(on: router)
        
        guard let response = result as? TMDBPopularResponseDTO else {
            throw APIError.notFound
        }
        return response
    }
    
    func getPopularMovies(
        apiKey: String,
        language: String = "en-US",
        page: Int = 1
    ) async throws -> TMDBPopularResponseDTO {
        let request = PopularMoviesRequest(apiKey: apiKey, language: language, page: page)
        let result = try await request.execute(on: router)
        
        guard let response = result as? TMDBPopularResponseDTO else {
            throw APIError.notFound
        }
        return response
    }
}

struct PopularShowsRequest: RequestTypeProtocol {
    typealias ResponseType = TMDBPopularResponseDTO
    
    let apiKey: String
    let language: String
    let page: Int
    
    var request: Request {
        var components = URLComponents()
        components.scheme = NetworkScheme.https.rawValue
        components.host = NetworkHost.tmdb.rawValue
        components.path = EndPoint.popularShows.rawValue
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: String(page))
        ]
        let path = components.url?.absoluteString ?? ""
        return Request(path: path, method: .get)
    }
}

struct PopularMoviesRequest: RequestTypeProtocol {
    typealias ResponseType = TMDBPopularResponseDTO
    
    let apiKey: String
    let language: String
    let page: Int
    
    var request: Request {
        var components = URLComponents()
        components.scheme = NetworkScheme.https.rawValue
        components.host = NetworkHost.tmdb.rawValue
        components.path = EndPoint.popularMovies.rawValue
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: String(page))
        ]
        let path = components.url?.absoluteString ?? ""
        return Request(path: path, method: .get)
    }
}
