//
//  NewCategoryTableViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/16/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit
import CoreData

protocol FilterCategoryDelegate: class {
    func finishCategoryPassing(categories: [Category])
}

class NewCategoryTableViewController: UITableViewController {

    // MARK: - IBOutlets

    // MARK: - Variables

    var fetchedResultController: NSFetchedResultsController<Category>?

    var categoriesChosen: [Category] = []

    weak var delegate: FilterCategoryDelegate?

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsMultipleSelection  = true

        let addCategoryButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                               target: self,
                                                               action: #selector(addCategory))

        navigationItem.rightBarButtonItem = addCategoryButton

        loadCategories()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.finishCategoryPassing(categories: categoriesChosen)
    }

    // MARK: - Methods

    func loadCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptorName: NSSortDescriptor = NSSortDescriptor(keyPath: \Category.name, ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptorName]
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

    @objc func addCategory() {
        let alert = UIAlertController(title: L10n.newCategory, message: L10n.enterCategoryName, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = L10n.name
        }

        alert.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: { [weak alert] (_) in
            guard let newName = alert?.textFields![0].text else { return }

            if newName.isEmpty {
                let alert = UIAlertController(title: L10n.oops, message: L10n.emptyField, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: { (_) in
                }))
                self.present(alert, animated: true, completion: nil)
            } else if self.categoryExists(name: newName) {
                let alert = UIAlertController(title: L10n.oops,
                                              message: L10n.categoryExists,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: { (_) in
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.saveCategory(name: newName)
            }
        }))

        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: { (_) in
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func categoryExists(name: String) -> Bool {
        if let categories = fetchedResultController?.fetchedObjects {
            return categories.contains(where: { (category) -> Bool in
                category.name?.lowercased() == name.lowercased()
            })
        }
        return false
    }

    func saveCategory(name: String?) {
        let category = Category(context: self.context)
        category.name = name
        self.saveContext()
    }

    func tableViewEmptyMessage() {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.bounds.size)
        let messageLabel: UILabel = UILabel(frame: rect)
        messageLabel.text = L10n.zeroCategories
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none

        navigationItem.leftBarButtonItem?.isEnabled = false
    }

    private func checkCell(cell: UITableViewCell, indexPath: IndexPath) {
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            if let name = fetchedResultController?.object(at: indexPath).name,
                let index = categoriesChosen.index(where: {$0.name == name}) {
                categoriesChosen.remove(at: index)
            }
        } else {
            cell.accessoryType = .checkmark
            if let category = fetchedResultController?.object(at: indexPath) {
                categoriesChosen.append(category)
            }
        }
    }

    // MARK: - IBActions

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (fetchedResultController?.fetchedObjects?.count ?? 0) == 0 {
            tableViewEmptyMessage()
            return 0
        }

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController?.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = fetchedResultController?.object(at: indexPath)
        cell.textLabel?.text = category?.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) {
            checkCell(cell: cell, indexPath: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) {
            checkCell(cell: cell, indexPath: indexPath)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewCategoryTableViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        tableView.reloadData()
    }

}
