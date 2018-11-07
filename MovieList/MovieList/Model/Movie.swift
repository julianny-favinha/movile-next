//
//  Movie.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let categories: [String]?
    let duration: String?
    let rating: Double?
    let summary: String?
    let image: String?
    let itemType: ItemType?
    let items: [Movie]?

    enum CodingKeys: String, CodingKey {
        case title
        case categories
        case duration
        case summary = "description"
        case rating
        case image
        case itemType
        case items
    }
}

struct Item: Codable {
    let title: String
    let image: String
}

enum ItemType: String, Codable {
    case movie
    case list
}
