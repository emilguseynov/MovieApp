//
//  SectionsModel.swift
//  MovieApp
//
//  Created by Emil Guseynov on 16.10.2022.
//

import Foundation

struct Section: Hashable {
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
    }
    
    enum ContentType: String {
        case movies = "Popular Movies"
        case tvShows = "Popular TV Shows"
    }
    
    
    let type: ContentType
    let items: [Result]
    
    
}


