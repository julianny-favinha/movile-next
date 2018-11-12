//
//  MoviesTableViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/6/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {

    var movies: [Movie] = []
    var selectedMovie: Movie?

    var releases: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // TODO: get from coredata
        movies = MoviesServices.movies

        if movies.count > 0 {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        tableView.reloadData()

        setTheme()
    }

    // MARK: Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
        }
    }

    fileprivate func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        self.view.backgroundColor = theme.backgroundColor

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barStyle = theme.barStyle
        self.navigationController?.navigationBar.isTranslucent = true

        self.tabBarController?.tabBar.barStyle = theme.barStyle

        self.tableView.backgroundColor = theme.backgroundColor
    }

    // MARK: IBActions

    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let barButtonSystemItem: UIBarButtonItem.SystemItem = !tableView.isEditing ?
            UIBarButtonItem.SystemItem.edit : UIBarButtonItem.SystemItem.done
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: barButtonSystemItem,
                                                           target: self,
                                                           action: #selector(editPressed(_:)))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if movies.count == 0 {
            tableViewEmptyMessage()
            return 0
        }

        return 1
    }

    func tableViewEmptyMessage() {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.bounds.size)
        let messageLabel: UILabel = UILabel(frame: rect)
        messageLabel.text = "You don't have any movies yet. \nStart creating one in the + button above!"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none

        navigationItem.leftBarButtonItem?.isEnabled = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemType = movies[indexPath.row].itemType else { return UITableViewCell() }

        switch itemType {
        case .list:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseTableCell", for: indexPath)
                as? ReleaseTableViewCell else { return UITableViewCell() }

            if let items = movies[indexPath.row].items {
                releases = items
            }

            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self

            cell.collectionView.reloadData()

            return cell
        case .movie:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath)
                as? MovieTableViewCell else { return UITableViewCell() }

            cell.prepareCell(with: movies[indexPath.row])

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "MovieDetailSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let itemType = movies[indexPath.row].itemType else { return false }

        switch itemType {
        case .list:
            return false
        case .movie:
            return true
        }
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // TODO: remove from coredata
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class,
//            // insert it into the array, and add a new row to the table view
//        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

extension MoviesTableViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return releases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReleaseCollectionCell",
                                                            for: indexPath)
            as? ReleaseCollectionViewCell else { return UICollectionViewCell() }

        cell.prepareCell(with: releases[indexPath.row])

        return cell
    }

}
