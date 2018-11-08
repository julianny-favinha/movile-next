//
//  NewMovieViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/7/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class NewMovieViewController: UIViewController {

    @IBOutlet weak var durationPickerView: UIPickerView!

    var durationComponents: [[Int]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setDurationPickerViewData()

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

    func setDurationPickerViewData() {
        var hours: [Int] = []
        for value in 0..<11 {
            hours.append(value)
        }

        var minutes: [Int] = []
        for value in 0..<60 {
            minutes.append(value)
        }

        durationComponents = [hours, minutes]
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        // TODO: save movie
        self.dismiss(animated: true, completion: nil)
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
