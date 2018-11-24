//
//  ItunesApi.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/23/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation

struct ItunesApi: Codable {
    let resultCount: Int
    let results: [ItunesApiResults]
}

struct ItunesApiResults: Codable {
    let previewUrl: String
}
