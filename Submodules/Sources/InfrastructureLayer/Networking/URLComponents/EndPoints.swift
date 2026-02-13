import Foundation

public enum EndPoint: String {
    case allMedias = "/api/breeds/list/all" //TODO: Update
    case breedImages = "/api/breed/%@/images" //TODO: remove if needed
    case popularShows = "/3/tv/popular"
    case popularMovies = "/3/movie/popular"
}
