//
//  ViewController.swift
//  Project21
//
//  Created by Александр Банников on 17.08.2020.
//  Copyright © 2020 AlexBanana. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let notificationDelay = UNNotificationAction(identifier: "delay", title: "Remind me later", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, notificationDelay], intentIdentifiers: [], options: [])

        center.setNotificationCategories([category])
    }
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         // pull out the buried userInfo dictionary
         let userInfo = response.notification.request.content.userInfo

         if let customData = userInfo["customData"] as? String {
             print("Custom data received: \(customData)")

             switch response.actionIdentifier {
             case UNNotificationDefaultActionIdentifier:
                 // the user swiped to unlock
                 print("Default identifier")
                 let ac = UIAlertController(title: "default", message: "wtf", preferredStyle: .alert)
                 ac.addAction(UIAlertAction(title: "ok", style: .default))
                 present(ac, animated: true)
                
             case "show":
                 // the user tapped our "show more info…" button
                 print("Show more information…")
                print("Default identifier")
                let ac = UIAlertController(title: "default", message: nil, preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction(title: "ok", style: .default))
                 ac.addAction(UIAlertAction(title: "not okay", style: .destructive))
                present(ac, animated: true)
                
             case "delay":
                let content = response.notification.request.content
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
                
             case "alarm":
                print("We a late")

             default:
                 break
             }
         }

         // you must call the completion handler when you're done
        completionHandler()
     }
}

