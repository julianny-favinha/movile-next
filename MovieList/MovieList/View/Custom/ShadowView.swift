//
//  ShadowView.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation
import UIKit

class ShadowView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.clipsToBounds = false
    }

}
