//
//  UIViewController+CoreData.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/16/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// swiftlint:disable force_cast
extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
// swiftlint:enable force_cast
