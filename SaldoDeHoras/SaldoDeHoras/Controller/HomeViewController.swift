//
//  ViewController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 20/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeView: HomeView!
    
    public var user: User?
    public var hoursDelegate: HoursDelegate!
    public var userDelegate: UserInfoDelegate?
    
    
    var hours:   [Int] = [3,  8,  9,  12]
    var minutes: [Int] = [30, 30, 30, 45]
    var days:    [Int] = [2, 3, 4, 5, 6]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let safeUser = self.user {
            safeUser.updateWorkedHours()
        }
        self.homeView.setup(user: self.user)
        self.setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // Button actions ------------------------
    
    @IBAction func checkIn(sender: Any) {
        if let safeUser = self.user {
            let today = Date()
            let todayDate = today as NSDate
            let check = Check(context: PersistenceService.context)
            check.date = todayDate
            safeUser.addToChecksofuser(check)
            safeUser.updateWorkedHours()
            safeUser.updateHoursBank()
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: user)
            if let checks = safeUser.checksofuser{
                if checks.count == 2 {
                    self.bookLunchNotification()
                }
            }
        }
    }
    
    @IBAction func animate(_ sender: UIButton) {
        let constraint = self.homeView.animationConstraint
        UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
            constraint!.constant = constraint!.constant == Constants.Values.Constraint.higherConstraint ? Constants.Values.Constraint.lowerConstraint : Constants.Values.Constraint.higherConstraint
            self.homeView.layoutIfNeeded()
        }
    }
    
    @IBAction func resetCoreData(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.checks)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceService.context.execute(deleteRequest)
            self.user?.paidHours = Constants.DefaultValues.zero
            self.user?.resetWeek()
            self.user?.updateWorkedHours()
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: self.user)
        } catch {}
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.main, bundle: nil)
        guard let optionsViewController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.optionsViewController) as? OptionsViewController else { return }
        self.userDelegate = optionsViewController
        if let safeUser = self.user {
            self.userDelegate?.userInfo(user: safeUser)
        }
        self.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    @IBAction func openHours(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.main, bundle: nil)
        guard let hoursViewController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.hoursViewController) as? HoursViewController else { return }
        self.userDelegate = hoursViewController
        if let user = self.user {
            self.userDelegate?.userInfo(user: user)
        }
        self.navigationController?.pushViewController(hoursViewController, animated: true)
    }
    
    
    @IBAction func createChecks(_ sender: UIButton) {
        self.createChecks()
    }
    
    //Auxiliary methods ------------------------
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.background
    }
    
    func createChecks() {
        for day in days {
            for (index, hour) in hours.enumerated() {
                self.createCheck(day: day, hour: hour, minute: minutes[index])
            }
        }
        self.user?.updateWorkedHours()
        self.user?.updateHoursBank()
        self.homeView.updateCheckLabels(user: self.user)
    }
    
    func createCheck(day: Int, hour: Int, minute: Int) {
        let today = Date()
        var calendar = NSCalendar.current
        calendar.locale = Locale(identifier: Constants.Locales.ptBR)
        let check = Check(context: PersistenceService.context)
        let components = NSDateComponents()
        components.hour = hour
        components.minute = minute
        components.day = day
        components.month = calendar.component(.month, from: today)
        components.year = calendar.component(.year, from: today)
        components.timeZone = .current
        guard let date = calendar.date(from: components as DateComponents) else {
            print (Constants.Error.dateConversionError)
            return
        }
        check.date = date as NSDate
        self.user?.addToChecksofuser(check)
        PersistenceService.saveContext()
    }
    
    func bookLunchNotification () {
        let today = Date()
        let calendar = NSCalendar.current
        let content = UNMutableNotificationContent()
        content.title = Constants.Messages.LuchNotification.title
        content.sound = UNNotificationSound.default()
        content.body = Constants.Messages.LuchNotification.body
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeInterval: Constants.Messages.LuchNotification.notificationTime, since: today))
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: Constants.Identifiers.lunchNotification, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let hasError = error {
                let alert = UIAlertController(title: Constants.Messages.NotificationAlertError.title, message: hasError.localizedDescription, preferredStyle: .alert)
                self.present(alert, animated: true)
            }
        }
    }
}

extension HomeViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}

