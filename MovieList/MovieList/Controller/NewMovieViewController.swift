//
//  NewMovieViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class NewMovieViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var missingTitleImageView: UIImageView!
    @IBOutlet weak var durationPickerView: UIPickerView!
    @IBOutlet weak var ratingTexField: UITextField!
    @IBOutlet weak var missingRatingImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var missingCategoriesImageView: UIImageView!
    
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!

    var durationComponents: [[Int]] = []

    var imagePickedBlock: ((UIImage) -> Void)?

    var selectedImage: UIImage?

    var categories: [Category] = [Category(type: CategoryType.action),
                                  Category(type: CategoryType.anime),
                                  Category(type: CategoryType.child),
                                  Category(type: CategoryType.comedy),
                                  Category(type: CategoryType.drama),
                                  Category(type: CategoryType.horror),
                                  Category(type: CategoryType.musical),
                                  Category(type: CategoryType.romance),
                                  Category(type: CategoryType.scientificFiction),
                                  Category(type: CategoryType.thriller)]
    var selectedCategories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.missingTitleImageView.isHidden = true
        self.missingRatingImageView.isHidden = true
        self.missingCategoriesImageView.isHidden = true

        setDurationPickerView()

//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        self.view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        configCollectionView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        // change height of collection view to show all cells
        let height: CGFloat = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightCollectionViewConstraint.constant = height
        self.view.setNeedsLayout()
    }

//    @objc func dismissKeyboard() {
//        self.view.endEditing(true)
//    }

    func setDurationPickerView() {
        var hours: [Int] = []
        for value in 0..<11 {
            hours.append(value)
        }

        var minutes: [Int] = []
        for value in 0..<60 {
            minutes.append(value)
        }

        durationComponents = [hours, minutes]

        let labelWidth = durationPickerView.frame.width / CGFloat(durationPickerView.numberOfComponents)

        let texts: [String] = ["Hours", "Minutes"]
        for index in 0..<texts.count {
            let xPosition = durationPickerView.frame.origin.x + labelWidth * CGFloat(index)
            let label: UILabel = UILabel(frame: CGRect(x: xPosition,
                                                       y: 0,
                                                       width: labelWidth,
                                                       height: 20))
            label.text = texts[index]
            label.textAlignment = .center
            durationPickerView.addSubview(label)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let height = rect.size.height
        scrollView.contentInset.bottom = height + 10
        scrollView.scrollIndicatorInsets.bottom = height + 10
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }

    // MARK: - IBActions

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        var image: String!
        if let selectedImage = selectedImage {
            image = UUID().uuidString
        } else {
            image = "placeholder-large"
        }
        
        var title: String!
        if let titleSelected = titleTextField.text {
            if titleSelected.isEmpty {
                missingTitleImageView.isHidden = false
            } else {
                title = titleSelected
                missingTitleImageView.isHidden = true
            }
        } else {
            missingTitleImageView.isHidden = false
        }
        
        let duration = (durationPickerView.selectedRow(inComponent: 0), durationPickerView.selectedRow(inComponent: 1))
        
        var rating: Double!
        if let ratingString = ratingTexField.text,
            let ratingSelected = Double(ratingString.replacingOccurrences(of: ",", with: ".")) {
            rating = ratingSelected
            missingRatingImageView.isHidden = true
        } else {
            missingRatingImageView.isHidden = false
        }
        
        var categoriesString: [String] = []
        if selectedCategories.isEmpty {
            missingCategoriesImageView.isHidden = false
        } else {
            missingCategoriesImageView.isHidden = true
            categoriesString = selectedCategories.map { String($0.title) }
        }
        
        if missingCategoriesImageView.isHidden &&
            missingRatingImageView.isHidden &&
            missingTitleImageView.isHidden {
            MoviesServices.movies.append(Movie(title: title,
                                           categories: categoriesString,
                                           duration: "\(duration.0)h \(duration.1)min",
                                           rating: rating,
                                           summary: descriptionTextView.text,
                                           image: image,
                                           itemType: ItemType.movie,
                                           items: nil))

            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func chooseImagePressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension NewMovieViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return durationComponents.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationComponents[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(durationComponents[component][row])
    }

}

// MARK: - Extensions

extension NewMovieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)

            self.imageButton.imageView?.image = nil
            self.imageButton.imageView?.contentMode = .scaleAspectFit
            self.imageButton.setImage(image, for: .normal)
        } else {
            print("LOG: Error in getting image from photo library.")
        }
    }

}

extension NewMovieViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension NewMovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell",
                                                            for: indexPath)
            as? CategoryCollectionViewCell else { return UICollectionViewCell() }

        cell.prepareCell(category: categories[indexPath.row])
        cell.isUserInteractionEnabled = true

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categories[indexPath.row].selected = categories[indexPath.row].selected ? false : true

        if categories[indexPath.row].selected == false {
            if let index = self.selectedCategories.index(where: { element in
                return categories[indexPath.row].title == element.title
            }) {
                self.selectedCategories.remove(at: index)
            }
        } else {
            self.selectedCategories.append(categories[indexPath.row])
        }

        print("selectedCategories: \(self.selectedCategories)")

        collectionView.reloadItems(at: [indexPath])
    }

}
