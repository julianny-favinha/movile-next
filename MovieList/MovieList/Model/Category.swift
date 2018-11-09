//
//  Category.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/9/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation

enum CategoryType {
    case action
    case anime
    case child
    case comedy
    case drama
    case horror
    case musical
    case romance
    case scientificFiction
    case thriller
}

class Category {
    var title: String
    var icon: String
    var iconFilled: String
    public var selected: Bool = false

    init(type: CategoryType) {
        switch type {
        case .action:
            title = "Action"
            icon = "action"
            iconFilled = "action-filled"
        case .anime:
            title = "Anime"
            icon = "anime"
            iconFilled = "anime-filled"
        case .child:
            title = "Child"
            icon = "child"
            iconFilled = "child-filled"
        case .comedy:
            title = "Comedy"
            icon = "comedy"
            iconFilled = "comedy-filled"
        case .drama:
            title = "Drama"
            icon = "drama"
            iconFilled = "drama-filled"
        case .horror:
            title = "Horror"
            icon = "horror"
            iconFilled = "horror-filled"
        case .musical:
            title = "Musical"
            icon = "musical"
            iconFilled = "musical-filled"
        case .romance:
            title = "Romance"
            icon = "romance"
            iconFilled = "romance-filled"
        case .scientificFiction:
            title = "Scientific Fiction"
            icon = "scientific-fiction"
            iconFilled = "scientific-fiction-filled"
        case .thriller:
            title = "Thriller"
            icon = "thriller"
            iconFilled = "thriller-filled"
        }
    }
}
