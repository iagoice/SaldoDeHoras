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
        application.setMinimumBackgroundFetchInterval(3600*24)
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return true 
    }

    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceService.saveContext()
    }

}

