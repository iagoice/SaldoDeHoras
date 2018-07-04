//
//  AppDelegate.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 20/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
        }
        application.setMinimumBackgroundFetchInterval(TimeInterval(Constants.Values.Time.dayInSeconds))
        guard let lastCheck = User.getLastCheck() else { return true }
        guard let date = lastCheck as? Date else { return true }
        if date.compare(today) == .orderedAscending {
            do {
                let usersRequest: NSFetchRequest<User> = User.fetchRequest()
                let users = try PersistenceService.context.fetch(usersRequest)
                for user in users {
                    user.resetDay()
                }
            } catch {}
        }
        if today.isMonday() {
            do {
                let usersRequest: NSFetchRequest<User> = User.fetchRequest()
                let users = try PersistenceService.context.fetch(usersRequest)
                for user in users {
                    user.resetWeek()
                }
            } catch {}
        }
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try PersistenceService.context.fetch(fetchRequest)
            if today.isMonday() {
                for user in users {
                    user.resetWeek()
                }
            } else {
                for user in users {
                    user.resetDay()
                }
            }
        } catch {
            print (error.localizedDescription)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return true 
    }

    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceService.saveContext()
    }

}

