//
//  NotificationViewController.swift
//  MovieList
//
//  Created by Julianny Favinha on 11/16/18.
//  Copyright © 2018 MovileNext. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - Variables

    var movie: Movie?
    let center = UNUserNotificationCenter.current()

    // MARK: - Super Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.minimumDate = Date()

        center.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        center.getNotificationSettings { (settings) in
            print("Authorization status: \(settings.authorizationStatus.rawValue)")
        }

        let confirmAction = UNNotificationAction(identifier: "confirm", title: "OK", options: [.destructive])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancel", options: [])
        let category = UNNotificationCategory(identifier: "reminder",
                                              actions: [confirmAction, cancelAction],
                                              intentIdentifiers: [],
                                              hiddenPreviewsBodyPlaceholder: "",
                                              options: [.customDismissAction])
        center.setNotificationCategories([category])

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if error != nil {
                print(error!)
            } else {
                print(success)
            }
        }
    }

    // MARK: - IBActions

    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        let idNotification = String(Date().timeIntervalSince1970)

        let content = UNMutableNotificationContent()
        content.title = "Watch now the movie '\(movie?.title ?? "")'"
//        content.body = "So much \(movie?.categories?.first ?? "")!"
        content.body = "So much fun!"
        content.categoryIdentifier = "reminder"

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                             from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: idNotification, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error!)
            } else {
                DispatchQueue.main.async {
                    print("Notification registered at \(self.datePicker.date)")
                }
            }
        }

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension NotificationViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                            @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "confirm":
            break
        case "cancel":
            break
        case UNNotificationDefaultActionIdentifier:
            print("Touched in notification")
        case UNNotificationDismissActionIdentifier:
            print("Dismissed notification")
        default:
            break
        }
        completionHandler()
    }
}
