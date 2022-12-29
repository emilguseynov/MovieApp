//
//  Genres.swift
//  MovieApp
//
//  Created by Emil Guseynov on 31.10.2022.
//
import Foundation

struct Genres: Decodable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Decodable {
    let id: Int
    let name: String
}
