//
//  CategoryCollectionViewCell.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/9/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func prepareCell(category: Category) {
        nameLabel.text = category.title

        if category.selected {
            iconImageView.image = UIImage(named: category.iconFilled)
            nameLabel.textColor = #colorLiteral(red: 0.5960784314, green: 0.1450980392, blue: 0.5411764706, alpha: 1)
        } else {
            iconImageView.image = UIImage(named: category.icon)
            nameLabel.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        }
    }
}
