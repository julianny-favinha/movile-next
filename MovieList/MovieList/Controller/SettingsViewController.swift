//
//  SettingsViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/12/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var autoPlaySwitch: UISwitch!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoPlaySwitch.isOn = UserDefaultsManager.autoPlay()
        colorSegmentedControl.selectedSegmentIndex = UserDefaultsManager.colorNumber()
    }
    
    @IBAction func autoPlayChanged(_ sender: UISwitch) {
        UserDefaultsManager.setAutoPlay(to: autoPlaySwitch.isOn)
    }
    
    @IBAction func colorSegmentedControlChanged(_ sender: UISegmentedControl) {
        UserDefaultsManager.setColor(to: sender.selectedSegmentIndex)
    }
    
}
