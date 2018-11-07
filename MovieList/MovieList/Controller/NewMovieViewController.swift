//
//  NewMovieViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class NewMovieViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        // TODO: save movie
        self.dismiss(animated: true, completion: nil)
    }

}
