//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var movie: Movie?

    fileprivate func configView() {
        titleLabel.text = movie?.title

        if let imageName = movie?.image,
            let image = UIImage(named: imageName) {
            posterImageView.image = image
        }

        durationLabel.text = movie?.duration

        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie?.rating ?? 0.0))"

        if let categories = movie?.categories {
            categoriesLabel.text = String(categories.reduce("", { result, next in
                result + next + ", "
            }).dropLast(2))
        }

        descriptionLabel.text = movie?.summary
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editMovie))

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as? UINavigationController
        if let destination = nav?.topViewController as? NewMovieViewController {
            destination.movie = movie
        }
    }

    @objc func editMovie() {
        performSegue(withIdentifier: "NewMovieSegue", sender: self)
    }
}
