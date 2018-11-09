//
//  MoviesServices.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/9/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation
import UIKit

class MoviesServices {
    static var movies: [Movie] = loadMovies()
    
    static func loadMovies() -> [Movie] {
        var movies: [Movie] = []

        guard let movieData = NSDataAsset(name: "movies")?.data else { return [] }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            movies = try decoder.decode([Movie].self, from: movieData)
        } catch {
            print(error)
        }

        return movies
    }
}
