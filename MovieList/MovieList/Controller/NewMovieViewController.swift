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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var missingTitleImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var ratingValueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var categoriesTextField: UITextField!
    @IBOutlet weak var missingCategoriesImageView: UIImageView!

    var durationComponents: [[Int]] = []

    var imagePickedBlock: ((UIImage) -> Void)?

    var selectedImage: UIImage?

    var movie: Movie?

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()

        self.missingTitleImageView.isHidden = true
        self.missingCategoriesImageView.isHidden = true

        configDatePicker()

        if let movie = movie {
            navigationController?.title = "Edit movie"
            configFields(movie: movie)
        }

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
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
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    fileprivate func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        self.view.backgroundColor = theme.backgroundColor

        self.navigationController?.navigationBar.barStyle = theme.barStyle

        self.titleLabel.textColor = theme.labelColor
        self.durationLabel.textColor = theme.labelColor
        self.ratingLabel.textColor = theme.labelColor
        self.ratingValueLabel.textColor = theme.labelColor
        self.descriptionLabel.textColor = theme.labelColor
        self.categoriesLabel.textColor = theme.labelColor
    }

    func configDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                          target: self,
                                                          action: #selector(doneDate))
        let cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(cancelDate))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flexibleButton, doneButton]
        durationTextField.inputView = datePicker
        durationTextField.inputAccessoryView = toolbar
    }

    @objc func doneDate() {
        durationTextField.text = datePicker.date.formatted
        view.endEditing(true)
    }

    @objc func cancelDate() {
        view.endEditing(true)
    }

    func configFields(movie: Movie) {
        if let image = movie.image {
            self.imageButton.setImage(UIImage(named: image), for: .normal)
        }

        self.titleTextField.text = movie.title

        durationTextField.text = movie.duration

        if let rating = movie.rating {
            self.ratingValueLabel.text = String(rating)
        }

        self.descriptionTextView.text = movie.summary

        // TODO: put in text field the categories
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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

        let rating: Double = Double(ratingSlider.value)

        // TODO: get categories

        if missingCategoriesImageView.isHidden &&
            missingTitleImageView.isHidden {
            // TODO: save in coredata
            MoviesServices.movies.append(Movie(title: title,
                                           categories: [""],
                                           duration: "h " + "min",
                                           rating: rating,
                                           summary: descriptionTextView.text,
                                           image: image,
                                           itemType: ItemType.movie,
                                           items: nil))

            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Wait!", message: "Some fields must be completed",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

    @IBAction func ratingChangedValue(_ sender: UISlider) {
        ratingValueLabel.text = String(format: "%.1f", sender.value)
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
