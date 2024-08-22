import Foundation

struct CharactersRequest: Decodable {
    let info: Info
    let results: [CharacterApi]
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct CharacterApi: Identifiable, Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String?
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Decodable {
    let name: String
    let url: String
}

struct Character: Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String?
    let gender: String
    let origin: String
    let location: String
    let image: String
    var isFavourite: Bool = false
}

