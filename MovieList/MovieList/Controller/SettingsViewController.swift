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

    @IBOutlet weak var autoPlayLabel: UILabel!
    @IBOutlet weak var autoPlaySwitch: UISwitch!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!

    // MARK: - Variables

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()

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

    @objc func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        self.view.backgroundColor = theme.backgroundColor
        self.autoPlayLabel.textColor = theme.labelColor
        self.colorLabel.textColor = theme.labelColor
        self.navigationController?.navigationBar.barStyle = theme.barStyle
        self.tabBarController?.tabBar.barStyle = theme.barStyle
    }

    // MARK: - IBActions

    @IBAction func autoPlayChanged(_ sender: UISwitch) {
        UserDefaultsManager.setAutoPlay(to: autoPlaySwitch.isOn)
    }

    @IBAction func colorSegmentedControlChanged(_ sender: UISegmentedControl) {
        UserDefaultsManager.setColor(to: sender.selectedSegmentIndex)
        setTheme()
    }

}
