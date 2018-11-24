//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit
import AVKit

class MovieDetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Variables

    var movie: Movie?
    var player: AVPlayer!

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

        configVideoView()
    }

    override func viewWillAppear(_ animated: Bool) {
        setTheme()

        if UserDefaultsManager.autoPlay() {
            player?.play()
        }
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

    fileprivate func configVideoView() {
        guard let title = movie?.title else {
            self.videoView.isHidden = true
            self.playVideoButton.isHidden = true
            return
        }

        REST.load(movieName: title) { (url, error) in
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.videoView.isHidden = true
                    self.playVideoButton.isHidden = true
                }
            } else {
                guard let url = url else {
                    self.videoView.isHidden = true
                    self.playVideoButton.isHidden = true
                    return
                }
                self.player = AVPlayer(url: url)
                let layer: AVPlayerLayer = AVPlayerLayer(player: self.player)
                layer.frame = self.videoView.bounds
                layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.videoView.layer.addSublayer(layer)
            }
        }
    }

    fileprivate func configView() {
        titleLabel.text = movie?.title

        durationLabel.text = movie?.duration?.formatted

        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie?.rating ?? 0.0))"

        if let categories = movie?.categories, let arrayCategories = Array(categories) as? [Category] {
            categoriesLabel.text = String(arrayCategories.reduce("", { result, next in
                if let name = next.name {
                    return result + name + ", "
                }
                return result
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
        performSegue(withIdentifier: StoryboardSegue.MovieDetail.newMovieSegue.rawValue, sender: self)
    }

    @objc func notify() {
        performSegue(withIdentifier: StoryboardSegue.MovieDetail.notificationSegue.rawValue, sender: self)
    }

    // MARK: - IBActions

    @IBAction func playVideo(_ sender: Any) {
        playVideoButton.isHidden = true
        player?.play()
    }
}
