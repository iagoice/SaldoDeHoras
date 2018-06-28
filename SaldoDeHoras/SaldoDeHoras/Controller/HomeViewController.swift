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
    
    enum Filter {
        case day
        case week
    }
    
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
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: user)
            if self.homeView.sortChecks(checks: safeUser.checksofuser!).count == 2 {
                let today = Date()
                let calendar = NSCalendar.current
                var content = UNMutableNotificationContent()
                content.title = "Hora de voltar do almoço"
                content.sound = UNNotificationSound.default()
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
        let today = Date()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hoursViewController = storyboard.instantiateViewController(withIdentifier: "HoursViewController") as! HoursViewController
        self.hoursDelegate = hoursViewController
        self.userDelegate = hoursViewController
        let dayWorkedHours = self.calculateDayWorkedHours(date: today)
        let weekWorkedHours = self.calculateWeekWorkedHours()
        self.hoursDelegate.getHours(dayHours: dayWorkedHours, weekHours: weekWorkedHours)
        if let user = self.user {
            self.userDelegate?.userInfo(user: user)
        }
        self.navigationController?.pushViewController(hoursViewController, animated: true)
    }
    
    
    @IBAction func createChecks(_ sender: UIButton) {
        let today = Date()
        self.createChecks()
        self.calculateDayWorkedHours(date: today)
        self.calculateWeekWorkedHours()
    }
    
    //Auxiliary methods ------------------------
    
    func calculateDayWorkedHours(date: Date) -> Int {
        guard let checks = self.user?.checksofuser else { return 0 }
        let calendar = NSCalendar.current
        var hours = 0
        let dayChecks = self.filterChecks(checks: checks, filter: .day, date: date)
        for (index, check) in dayChecks.enumerated() {
            if index.isEven() && index < dayChecks.count - 1 {
                let timeIn =  calendar.component(.hour, from: check.date! as Date)
                let timeOut = calendar.component(.hour, from: dayChecks[index+1].date! as Date)
                hours += timeOut - timeIn
            }
        }
        if !dayChecks.count.isEven() && date == Date() {
                let lastCheck = dayChecks[dayChecks.count-1].date
                let checkHour = calendar.component(.hour, from: lastCheck! as Date)
                let now = calendar.component(.hour, from: Date())
                let hoursFromLastCheck = now - checkHour
                hours += hoursFromLastCheck
        }
        return hours
    }
    
    func calculateWeekWorkedHours() -> Int {
        var weekHoursWorked = 0
        let weekDays = Date.getWeekDays()
        for day in weekDays {
            let weekDayHoursWorked = self.calculateDayWorkedHours(date: day)
            weekHoursWorked += weekDayHoursWorked
        }
        return weekHoursWorked
    }
    
    
    
    func filterChecks (checks: NSSet, filter: Filter, date: Date) -> [Check] {
        var filteredChecks = [Check]()
        let calendar = Calendar(identifier: .gregorian)
        filteredChecks = checks.filter({ (checkIn) -> Bool in
            let check = checkIn as! Check
            let checkDate = check.date! as Date
            if filter == .day {
                return calendar.compare(date, to: checkDate, toGranularity: .day) == .orderedSame
            }
                return calendar.compare(date, to: checkDate, toGranularity: .weekOfMonth) == .orderedSame
        }) as! [Check]
        filteredChecks.sort { (check1, check2) -> Bool in
            return check1.date!.compare(check2.date! as Date ) == .orderedAscending
        }
        return filteredChecks
    }
    
    func createChecks() {
        for hour in hours {
            self.createCheck(hour: hour, minute: 0)
        }
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

