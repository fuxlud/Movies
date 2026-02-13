public struct MediasDTO: Decodable {

    let medias: [BreedDTO]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BreedKey.self)
        var extractedMedias: [BreedDTO] = []
        for key in container.allKeys{
            extractedMedias.append(BreedDTO(name: key.stringValue))
        }
        medias = extractedMedias
    }

    struct BreedKey: CodingKey {
        
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}
