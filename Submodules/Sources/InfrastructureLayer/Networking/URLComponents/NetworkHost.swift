import Foundation

public enum NetworkHost: String {
    case dogs = "dog.ceo" //TODO: remove
    case tmdb = "api.themoviedb.org"
}

public enum TMDBImageSize: String {
    case w185
    case w342
    case w500
    case w780
    case original
}

public extension NetworkHost {
    static func tmdbImageURL(path: String?, size: TMDBImageSize = .w500) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return URL(
            string: "\(NetworkScheme.https.rawValue)://image.tmdb.org/t/p/\(size.rawValue)\(path)"
        )
    }
}
