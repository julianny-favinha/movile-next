//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Julianny Favinha on 11/23/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import MovieList

class MovieListTests: FBSnapshotTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        recordMode = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSettingsSnapshot() {
        let storyboard = UIStoryboard(name: StoryboardScene.Settings.storyboardName, bundle: nil)
        XCTAssertNotNil(storyboard)
        guard let viewController = storyboard.instantiateViewController(withIdentifier:
            String(describing: SettingsViewController.self)) as? SettingsViewController else {
                XCTAssert(false)
                return
        }
        _ = viewController.view
        FBSnapshotVerifyView(viewController.view)
    }

}
