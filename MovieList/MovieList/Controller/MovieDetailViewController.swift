//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Variables

    var movie: Movie?

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        let editMovieButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                               target: self,
                                                               action: #selector(editMovie))

        let notificationButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"),
                                                                  style: .done,
                                                                  target: self,
                                                                  action: #selector(notify))

        navigationItem.rightBarButtonItems = [notificationButton, editMovieButton]

        configView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setTheme),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        setTheme()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // notification
        if let destination = segue.destination as? NotificationViewController {
            destination.movie = movie
        }

        // edit movie
        if let nav = segue.destination as? UINavigationController,
            let destination = nav.topViewController as? NewMovieViewController {
            destination.movie = movie
        }
    }

    // MARK: - Methods

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

    @objc fileprivate func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        self.view.backgroundColor = theme.backgroundColor
        self.titleLabel.textColor = theme.labelColor
        self.ratingLabel.textColor = theme.labelColor
        self.durationLabel.textColor = theme.labelColor
        self.categoriesLabel.textColor = theme.labelColor
        self.descriptionLabel.textColor = theme.labelColor

        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barStyle = theme.barStyle
        self.navigationController?.navigationBar.isTranslucent = true
    }

    @objc func editMovie() {
        performSegue(withIdentifier: "NewMovieSegue", sender: self)
    }

    @objc func notify() {
        performSegue(withIdentifier: "NotificationSegue", sender: self)
    }

    // MARK: - IBActions
}
