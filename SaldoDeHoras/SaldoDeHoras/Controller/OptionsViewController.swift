//
//  OptionsViewController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 26/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class OptionsViewController: UIViewController {
    var user: User?
    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        self.setupTableView()
        self.setupBackButton()
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupPickers()
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: Constants.backButton, style: .plain, target: self, action: #selector(saveOptionsAndPopViewController))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func saveOptionsAndPopViewController() {
        let calendar = NSCalendar.current
        let unsafePicker = self.optionsTableView.cellForRow(at: IndexPath(row: Constants.Indices.picker, section: Constants.Indices.section))?.subviews[Constants.Indices.subviewPosition]
        let unsafeDayPicker = self.optionsTableView.cellForRow(at: IndexPath(row: Constants.Indices.dayPicker, section: Constants.Indices.section))?.subviews[Constants.Indices.subviewPosition]
        guard let picker = unsafePicker as? UIDatePicker else { return }
        guard let dayPicker = unsafeDayPicker as? UIPickerView else { return }
        let hour = String(calendar.component(.hour, from: picker.date))
        let minute = String(calendar.component(.minute, from: picker.date))
        guard let user = self.user else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        guard let options = user.optionsOfUser else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        guard let checkInTime = options.checkInTime else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if hour != String(checkInTime.split(separator: Constants.separator)[Constants.Indices.separatorHour]) ||
           minute != String(checkInTime.split(separator: Constants.separator)[Constants.Indices.separatorMinute]) ||
            String(dayPicker.selectedRow(inComponent: 0)) != self.user?.optionsOfUser?.workWeek {
            self.setupWeekNotifications(picker: picker, calendar: calendar, options: options)
        }
        self.user?.optionsOfUser?.checkInTime = "\(hour):\(minute)"
        PersistenceService.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupWeekNotifications(picker: UIDatePicker, calendar: Calendar, options: Options) {
        let week = Date.getWeekDays(workSaturday: options.workWeek == "Sábado")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["checkIn"])
        for weekDay in week {
            let content = UNMutableNotificationContent()
            content.title = "Está na hora de bater o ponto!"
            content.sound = UNNotificationSound.default()
            content.body = ""
            var components = DateComponents()
            components.month = calendar.component(.weekOfMonth, from: weekDay)
            components.day = calendar.component(.day, from: weekDay)
            components.year = calendar.component(.year, from: weekDay)
            components.minute = calendar.component(.minute, from: picker.date) < 15 ? 60 - calendar.component(.minute, from: picker.date) - 15 : calendar.component(.minute, from: picker.date) - 15
            components.hour = calendar.component(.minute, from: picker.date) < 15 ? calendar.component(.hour, from: picker.date) - 1 : calendar.component(.hour, from: picker.date)
            let triggerDate = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "checkIn", content: content, trigger: triggerDate)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let hasError = error {
                    let alert = UIAlertController(title: "Erro ao agendar notificação de entrada", message: hasError.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
        
        if options.workWeek == "Sábado" {
            let week = Date.getWeekDays(workSaturday: options.workWeek == "Sábado")
            let content = UNMutableNotificationContent()
            content.title = "Está na hora de bater o ponto!"
            content.sound = UNNotificationSound.default()
            content.body = ""
            var components = DateComponents()
            guard let saturday = week.last else { return }
            components.month = calendar.component(.weekOfMonth, from: saturday)
            components.day = calendar.component(.day, from: saturday)
            components.year = calendar.component(.year, from: saturday)
            components.minute = calendar.component(.minute, from: picker.date) < 15 ? 60 - calendar.component(.minute, from: picker.date) - 15 : calendar.component(.minute, from: picker.date) - 15
            components.hour = calendar.component(.minute, from: picker.date) < 15 ? calendar.component(.hour, from: picker.date) - 1 : calendar.component(.hour, from: picker.date)
            let triggerDate = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "checkIn", content: content, trigger: triggerDate)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let hasError = error {
                    let alert = UIAlertController(title: "Erro ao agendar notificação de entrada", message: hasError.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
    func setupPickers() {
        if let safeUser = self.user, let options = safeUser.optionsOfUser {
            for index in 0...2 {
                switch index {
                case 0:
                    guard let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
                    guard let timePicker = cell.subviews[3] as? UIDatePicker else { return }
                    guard let checkInTime = options.checkInTime else { return }
                    let checkInComponents = checkInTime.split(separator: ":")
                    var components = DateComponents()
                    let calendar = NSCalendar.current
                    components.hour = Int(checkInComponents[0])
                    components.minute = Int(checkInComponents[1])
                    guard let date = calendar.date(from: components) else { return }
                    
                    timePicker.date = date
                case 1:
                    guard let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
                    guard let workWeekPicker = cell.subviews[3] as? UIPickerView else { return }
                    let userOption = options.workWeek
                    let pickerIndex = Constants.Options.days.index { (day) -> Bool in
                        return day == userOption
                    }
                    if let index = pickerIndex {
                        workWeekPicker.selectRow(index, inComponent: 0, animated: false)
                    }
                case 2:
                    guard let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
                    guard let workWeekPicker = cell.subviews[3] as? UIPickerView else { return }
                    let userOption = options.weekWorkHours
                    let pickerIndex = Constants.Options.hours.index { (hour) -> Bool in
                        return hour == userOption
                    }
                    if let index = pickerIndex {
                        workWeekPicker.selectRow(index, inComponent: 0, animated: false)
                    }
                default:
                    print("ue")
                }
            
            }
            
        }
    }
    
    func setupTableView() {
        self.optionsTableView.separatorStyle = .none
        self.optionsTableView.isScrollEnabled = false
    }
}

extension OptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell(style: .default, reuseIdentifier: "cell") }
        switch indexPath.row {
        case 0:
            self.setupCellWithTimePicker(cell: cell, identifier: "time", message: "Hora de entrada: ", width: 100)
        case 1:
            self.setupCellWithPicker(cell: cell, identifier: "days", message: "Semana até dia: ", width: 120)
        case 2:
            self.setupCellWithPicker(cell: cell, identifier: "hours", message: "Duração semanal da jornada: ", width: 50)
        default:
            print()
        }
        return cell
    }
    
    func setupCellWithTimePicker(cell: UITableViewCell, identifier: String, message: String, width: CGFloat) {
        let pickerFrame = CGRect(x: cell.frame.maxX - width , y: cell.frame.minY, width: width, height: cell.frame.height)
        let picker = UIDatePicker(frame: pickerFrame)
        picker.accessibilityIdentifier = identifier
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "pt_BR")
        
        let frame = CGRect(x: cell.frame.minX + 20, y: cell.frame.minY, width: cell.frame.width - 60, height: cell.frame.height)
        let label = UILabel(frame: frame)
        label.text = message
        label.font = label.font.withSize(16.0)
        
        cell.addSubview(label)
        cell.addSubview(picker)
    }
    
    func setupCellWithPicker(cell: UITableViewCell, identifier: String, message: String, width: CGFloat) {
        let pickerFrame = CGRect(x: cell.frame.maxX - width , y: cell.frame.minY, width: width, height: cell.frame.height)
        let picker = UIPickerView(frame: pickerFrame)
        picker.accessibilityIdentifier = identifier
        picker.dataSource = self
        picker.delegate = self

        let frame = CGRect(x: cell.frame.minX + 20, y: cell.frame.minY, width: cell.frame.width - 60, height: cell.frame.height)
        let label = UILabel(frame: frame)
        label.text = message
        label.font = label.font.withSize(16.0)

        cell.addSubview(label)
        cell.addSubview(picker)
    }
}

extension OptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension OptionsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.accessibilityIdentifier == "time" {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case "days":
            return Constants.Options.days.count
        case "hours":
            return Constants.Options.hours.count
        default:
            return 0
        }
    }
}

extension OptionsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "hours":
            return String(Constants.Options.hours[row])
        case "days":
            return String(Constants.Options.days[row])
        default:
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "days":
            if let user = self.user {
                if let options = user.optionsOfUser {
                    options.workWeek = Constants.Options.days[row]
                    user.updateWorkedHours()
                    PersistenceService.saveContext()
                    
                } else {
                    let options = Options(context: PersistenceService.context)
                    options.workWeek = Constants.Options.days[row]
                    user.optionsOfUser = options
                    PersistenceService.saveContext()
                }
            }
        case "hours":
            if let user = self.user {
                if let options = user.optionsOfUser {
                    options.weekWorkHours = Int16(Constants.Options.hours[row])
                    user.updateWorkedHours()
                    PersistenceService.saveContext()
                } else {
                    let options = Options(context: PersistenceService.context)
                    options.weekWorkHours = Int16(Constants.Options.hours[row])
                    user.optionsOfUser = options
                    PersistenceService.saveContext()
                }
            }
        default:
            print()
        }
    }
}

extension OptionsViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}
