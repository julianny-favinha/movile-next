//
//  SettingsView.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/23/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit
import Cartography

extension SettingsViewController {

    func defineVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.contentMode = .scaleToFill
        return stackView
    }

    func defineHorizontalAutoPlayStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.contentMode = .scaleToFill
        return stackView
    }

    func defineAutoPlayLabel() -> UILabel {
        let label = UILabel()
        label.text = L10n.autoPlay
        return label
    }

    func defineAutoPlaySwitch() -> UISwitch {
        let autoPlaySwitch = UISwitch()
        autoPlaySwitch.isOn = UserDefaultsManager.autoPlay()
        autoPlaySwitch.addTarget(self, action: #selector(autoPlayChanged(_:)), for: .valueChanged)
        return autoPlaySwitch
    }

    func defineHorizontalColorStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.contentMode = .scaleToFill
        return stackView
    }

    func defineColorLabel() -> UILabel {
        let label = UILabel()
        label.text = L10n.color
        return label
    }

    func defineColorSegmentedControl() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: [L10n.light, L10n.dark])
        segmentedControl.selectedSegmentIndex = UserDefaultsManager.colorNumber()
        segmentedControl.addTarget(self, action: #selector(colorSegmentedControlChanged(_:)
            ), for: .valueChanged)
        return segmentedControl
    }

    func setupInitialState() {
        self.navigationItem.title = L10n.settings
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.verticalStackView = defineVerticalStackView()
        self.horizontalAutoPlayStackView = defineHorizontalAutoPlayStackView()
        self.autoPlayLabel = defineAutoPlayLabel()
        self.autoPlaySwitch = defineAutoPlaySwitch()
        self.horizontalColorStackView = defineHorizontalColorStackView()
        self.colorLabel = defineColorLabel()
        self.colorSegmentedControl = defineColorSegmentedControl()

        self.view.addSubview(verticalStackView)
        self.horizontalAutoPlayStackView.addArrangedSubview(self.autoPlayLabel)
        self.horizontalAutoPlayStackView.addArrangedSubview(self.autoPlaySwitch)
        self.verticalStackView.addArrangedSubview(self.horizontalAutoPlayStackView)
        self.verticalStackView.addArrangedSubview(self.horizontalColorStackView)
        self.horizontalColorStackView.addArrangedSubview(self.colorLabel)
        self.horizontalColorStackView.addArrangedSubview(self.colorSegmentedControl)
    }

    override func viewDidLayoutSubviews() {
        setupStackView()
    }

    func setupStackView() {
        constrain(verticalStackView) { view in
            guard let superview = view.superview else { return }
            guard let navigationBar = self.navigationController?.navigationBar else { return }
            view.top == superview.top + navigationBar.bounds.height + 100
            view.leading == superview.leading + 16
            view.trailing == superview.trailing - 16
            view.centerX == superview.centerX
        }
    }

    @objc func setTheme() {
        let colorNumber = UserDefaultsManager.colorNumber()
        let theme: Theme = colorNumber == 0 ? LightTheme() : DarkTheme()

        self.view.backgroundColor = theme.backgroundColor
        self.autoPlayLabel.textColor = theme.labelColor
        self.colorLabel.textColor = theme.labelColor
        self.navigationController?.navigationBar.barStyle = theme.barStyle
        self.tabBarController?.tabBar.barStyle = theme.barStyle
    }

}
