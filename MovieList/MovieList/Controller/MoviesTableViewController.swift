//
//  MoviesTableViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/6/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    // MARK: - IBOutlets

    // MARK: - Variables

    var selectedMovie: Movie?

    var fetchedResultController: NSFetchedResultsController<Movie>?

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (fetchedResultController?.fetchedObjects?.count ?? 0) > 0 {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        loadMovies()
        tableView.reloadData()

        setTheme()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setTheme),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailViewController {
            destination.movie = selectedMovie
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    func loadMovies() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false

        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(keyPath: \Movie.title, ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultController?.delegate = self

        do {
            try fetchedResultController?.performFetch()
        } catch {
            print(error)
        }
    }

    @objc fileprivate func setTheme() {
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

    // MARK: - IBActions

    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let barButtonSystemItem: UIBarButtonItem.SystemItem = !tableView.isEditing ?
            UIBarButtonItem.SystemItem.edit : UIBarButtonItem.SystemItem.done
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: barButtonSystemItem,
                                                           target: self,
                                                           action: #selector(editPressed(_:)))
    }

    // MARK: - Table view data source

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
        if (fetchedResultController?.fetchedObjects?.count ?? 0) == 0 {
            tableViewEmptyMessage()
            return 0
        }

        tableView.backgroundView = UIView()
        return fetchedResultController?.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath)
            as? MovieTableViewCell else { return UITableViewCell() }

        guard let movie = fetchedResultController?.object(at: indexPath) else { return UITableViewCell() }

        cell.prepareCell(with: movie)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = fetchedResultController?.object(at: indexPath) else { return }
        selectedMovie = movie
        performSegue(withIdentifier: StoryboardSegue.Movies.movieDetailSegue.rawValue, sender: self)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let movie = fetchedResultController?.object(at: indexPath) else { return }
            context.delete(movie)
            saveContext()
            tableView.reloadData()
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

// MARK: - Extensions

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
