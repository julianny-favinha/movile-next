//
//  ReleaseCollectionViewCell.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/9/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class ReleaseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func prepareCell(with movie: Movie) {
        titleLabel.text = movie.title
        if let imageData = movie.image,
            let image = UIImage(data: imageData) {
            posterImageView.image = image
        }
    }
}
