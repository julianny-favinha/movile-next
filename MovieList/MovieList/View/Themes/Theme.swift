//
//  Theme.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/12/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation
import UIKit

enum ThemeType: Int {
    case light = 0
    case dark = 1
}

protocol Theme: class {
    var backgroundColor: UIColor { get }
    var labelColor: UIColor { get }
    var barStyle: UIBarStyle { get }
}
