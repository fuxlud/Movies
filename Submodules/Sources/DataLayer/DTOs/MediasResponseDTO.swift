struct MediasResponseDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case medias = "message"
    }
    
    let medias: MediasDTO
}
