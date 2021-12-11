import Foundation

struct MoviesResult: Decodable {
    let err: String
    let status: Int
    let data: Movies
}

struct Movies: Decodable {
    let movies: [Movie]
    let movies_last_update: Int
}

struct Movie: Decodable {
    let id: String
    let name: String
    let year: String
    let category: String
    let cenimasId: [Int]
}

struct MovieDescription: Decodable {
    let status:Int
    let err: String
    let data:MovieDetailed
}

//struct error: Decodable {
//    let id: String
//    let name: String
//}

struct MovieDetailed: Decodable {
    let id: String
    let name: String
    let year: String
    let category: String
    let description: String
    let imageUrl: String
    let promoUrl: String
    let rate: String
    let hour: String
    let cenimasId: [Int]
}

struct Host: Decodable {
    let err: String
    let status: Int
    let data: HostUrl
}

struct HostUrl: Decodable {
    let url: String
}
