//
//  SettingsViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/12/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var autoPlayLabel: UILabel!
    @IBOutlet weak var autoPlaySwitch: UISwitch!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        autoPlaySwitch.isOn = UserDefaultsManager.autoPlay()
        colorSegmentedControl.selectedSegmentIndex = UserDefaultsManager.colorNumber()

        setTheme()
    }

    @IBAction func autoPlayChanged(_ sender: UISwitch) {
        UserDefaultsManager.setAutoPlay(to: autoPlaySwitch.isOn)
    }

    @IBAction func colorSegmentedControlChanged(_ sender: UISegmentedControl) {
        UserDefaultsManager.setColor(to: sender.selectedSegmentIndex)
        setTheme()
    }

    func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        self.view.backgroundColor = theme.backgroundColor
        self.autoPlayLabel.textColor = theme.labelColor
        self.colorLabel.textColor = theme.labelColor
        self.navigationController?.navigationBar.barStyle = theme.barStyle
        self.tabBarController?.tabBar.barStyle = theme.barStyle
    }

}
