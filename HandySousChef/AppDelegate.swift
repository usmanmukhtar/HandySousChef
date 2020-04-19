//
//  AppDelegate.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 9/25/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private func requestNotificationAuth(application: UIApplication, badge: Int?) {
        //permissions
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body"
        
        
        if let badge = badge {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            content.badge = NSNumber(value: currentBadgeCount)
        }
        
        let hours = [5,9,12];

        for hour in hours {
        
            var components = DateComponents()
            components.hour = hour;
            components.minute = 29;
            components.second = 00;
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true);

            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuth(application: application, badge: 1)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.badge, .sound, .alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let indentifier = response.actionIdentifier
       
       switch indentifier {
       case UNNotificationDismissActionIdentifier:
           print("Notification was dismissed")
           completionHandler()
           
       case UNNotificationDefaultActionIdentifier:
            print("User opened the app from the notification")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationTap"), object: nil)  
            completionHandler()
       default:
           print("The default case is called")
           completionHandler()
       }
    }
}
