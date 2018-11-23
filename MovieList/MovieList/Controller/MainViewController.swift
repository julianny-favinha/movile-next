//
//  MainViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/23/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navMoviesController = UIStoryboard(name: StoryboardScene.Movies.storyboardName, bundle: nil)
            .instantiateViewController(withIdentifier: StoryboardScene.Movies.moviesNavigationController.identifier)
        navMoviesController.tabBarItem = UITabBarItem(title: L10n.movies, image: #imageLiteral(resourceName: "list"), tag: 1)

        let settingsController = SettingsViewController()
        settingsController.tabBarItem = UITabBarItem(title: L10n.settings, image: #imageLiteral(resourceName: "settings"), tag: 2)
        let navSettingsController = UINavigationController(rootViewController: settingsController)

        viewControllers = [navMoviesController, navSettingsController]
    }

}
