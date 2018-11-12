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

    fileprivate func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        titleLabel.textColor = theme.labelColor
        durationLabel.textColor = theme.labelColor
        ratingLabel.textColor = theme.labelColor

        self.backgroundColor = theme.backgroundColor
    }

    func prepareCell(with movie: Movie) {
        setTheme()

        titleLabel.text = movie.title
        if let imageName = movie.image,
            let image = UIImage(named: imageName + "small") {
            posterImageView.image = image
        } else {
            posterImageView.image = #imageLiteral(resourceName: "placeholder")
        }
        durationLabel.text = movie.duration
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.rating ?? 0.0))"
    }

}
