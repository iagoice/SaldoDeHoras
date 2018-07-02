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
    
    
    var hours: [Int] = [8, 14, 15, 18]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeView.setup(user: user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // Button actions ------------------------
    
    @IBAction func checkIn(sender: Any) {
        let today = Date()
        if let safeUser = self.user {
            let todayDate = today as NSDate
            let check = Check(context: PersistenceService.context)
            check.date = todayDate
            safeUser.addToChecksofuser(check)
            safeUser.updateWorkedHours()
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: user)
            if let checks = safeUser.checksofuser, checks.count == 2 {
                let today = Date()
                let calendar = NSCalendar.current
                let content = UNMutableNotificationContent()
                content.title = "Hora de voltar do almoço"
                content.sound = UNNotificationSound.default()
                content.body = ""
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date(timeInterval: 45*60, since: today))
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: "lunch", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let hasError = error {
                        let alert = UIAlertController(title: "Erro ao agendar notificação de entrada", message: hasError.localizedDescription, preferredStyle: .alert)
                        self.present(alert, animated: true)
                    }
                }
            }
            
        }
    }
    
    @IBAction func animate(_ sender: UIButton) {
        let constraint = self.homeView.animationConstraint
        UIView.animate(withDuration: 0.5) {
            constraint!.constant = constraint!.constant == 20 ? -70 : 20
            self.homeView.layoutIfNeeded()
        }
    }
    
    @IBAction func resetCoreData(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Check")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceService.context.execute(deleteRequest)
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: self.user)
        } catch {}
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsViewController = storyboard.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        self.userDelegate = optionsViewController
        if let safeUser = self.user {
            self.userDelegate?.userInfo(user: safeUser)
        }
        self.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    
    @IBAction func openHours(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hoursViewController = storyboard.instantiateViewController(withIdentifier: "HoursViewController") as! HoursViewController
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
    
    func createChecks() {
        for hour in hours {
            self.createCheck(hour: hour, minute: 0)
        }
        self.homeView.updateCheckLabels(user: self.user)
    }
    
    func createCheck(hour: Int, minute: Int) {
        let today = Date()
        var calendar = NSCalendar.current
        calendar.locale = Locale(identifier: "pt_BR")
        let check = Check(context: PersistenceService.context)
        let components = NSDateComponents()
        components.hour = hour
        components.minute = minute
        components.day = calendar.component(.day, from: today)
        components.month = calendar.component(.month, from: today)
        components.year = calendar.component(.year, from: today)
        components.timeZone = .current
        let date = calendar.date(from: components as DateComponents)
        check.date = date! as NSDate
        self.user?.addToChecksofuser(check)
        PersistenceService.saveContext()
    }
    
}

extension HomeViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}

