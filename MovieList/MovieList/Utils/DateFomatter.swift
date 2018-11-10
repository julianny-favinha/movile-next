//
//  DateFomatter.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/10/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        let hours = Calendar.current.component(.hour, from: self)
        let minutes = Calendar.current.component(.minute, from: self)
        return "\(hours)h \(minutes)min"
    }
}
