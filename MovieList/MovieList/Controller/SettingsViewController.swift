//
//  SettingsViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/12/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - IBOutlets

    // MARK: - Variables

    var navigationBar: UINavigationBar = UINavigationBar()
    var verticalStackView: UIStackView = UIStackView()
    var horizontalAutoPlayStackView: UIStackView = UIStackView()
    var autoPlayLabel: UILabel! = UILabel()
    var autoPlaySwitch: UISwitch! = UISwitch()
    var horizontalColorStackView: UIStackView = UIStackView()
    var colorLabel: UILabel! = UILabel()
    var colorSegmentedControl: UISegmentedControl! = UISegmentedControl()

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()

        autoPlaySwitch.isOn = UserDefaultsManager.autoPlay()
        colorSegmentedControl.selectedSegmentIndex = UserDefaultsManager.colorNumber()

        setTheme()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setTheme),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    // MARK: - IBActions

    @IBAction func autoPlayChanged(_ sender: UISwitch) {
        UserDefaultsManager.setAutoPlay(to: autoPlaySwitch.isOn)
    }

    @IBAction func colorSegmentedControlChanged(_ sender: UISegmentedControl) {
        UserDefaultsManager.setColor(to: sender.selectedSegmentIndex)
        setTheme()
    }

}
