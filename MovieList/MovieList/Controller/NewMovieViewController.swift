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
    @IBOutlet weak var durationPickerView: UIPickerView!
    @IBOutlet weak var ratingTexField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoriesTextField: UITextField!

    var durationComponents: [[Int]] = []

    var imagePickedBlock: ((UIImage) -> Void)?

    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        setDurationPickerView()

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

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

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

    // MARK: IBActions

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        // TODO: save
        self.dismiss(animated: true, completion: nil)
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
