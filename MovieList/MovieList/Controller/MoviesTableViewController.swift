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

    override func viewDidLoad() {
        super.viewDidLoad()

        movies = MoviesServices.loadMovies()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barTintColor = nil
    }

    // MARK: Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
            as? MovieTableViewCell else { return UITableViewCell() }

        cell.prepareCell(with: movies[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "MovieDetailSegue", sender: self)
    }

    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
