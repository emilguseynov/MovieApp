// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let content = try? newJSONDecoder().decode(Content.self, from: jsonData)

import Foundation

// used only for JSON decoding
struct Content: Decodable {
    
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

}

struct Result: Decodable, Hashable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIds: [Int]
    let id: Int
    let name: String?
    let originCountry: [String]?
    let originalLanguage: String
    let originalName: String?
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int
    let adult: Bool?
    let originalTitle, releaseDate, title: String?
    let video: Bool?

}

