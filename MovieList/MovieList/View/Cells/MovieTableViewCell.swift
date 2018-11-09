//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/6/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func prepareCell(with movie: Movie) {
        titleLabel.text = movie.title
        if let imageName = movie.image,
            let image = UIImage(named: imageName + "small") {
            posterImageView.image = image
        } else {
            posterImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        durationLabel.text = movie.duration
        ratingLabel.text = "⭐️ \(movie.rating ?? 0.0)"
    }

}
