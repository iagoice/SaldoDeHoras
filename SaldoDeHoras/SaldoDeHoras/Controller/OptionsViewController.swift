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
            String(dayPicker.selectedRow(inComponent: Constants.Indices.pickerComponent)) != options.workWeek {
            self.setupWeekNotifications(picker: picker, calendar: calendar, options: options)
        }
        options.checkInTime = "\(hour):\(minute)"
        PersistenceService.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupWeekNotifications(picker: UIDatePicker, calendar: Calendar, options: Options) {
        let week = Date.getWeekDays(workSaturday: options.workWeek == Constants.saturday)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Constants.Identifiers.checkInNotification])
        for weekDay in week {
            let content = UNMutableNotificationContent()
            content.title = Constants.Messages.CheckInNotification.title
            content.sound = UNNotificationSound.default()
            content.body = Constants.Messages.CheckInNotification.body
            var components = DateComponents()
            components.month = calendar.component(.weekOfMonth, from: weekDay)
            components.day = calendar.component(.day, from: weekDay)
            components.year = calendar.component(.year, from: weekDay)
            let minutes = calendar.component(.minute, from: picker.date)
            components.minute = minutes < Constants.Values.Time.minutesUntilNotification ? Constants.Values.Time.minutesInHour - minutes - Constants.Values.Time.minutesUntilNotification : calendar.component(.minute, from: picker.date) - Constants.Values.Time.minutesUntilNotification
            components.hour = calendar.component(.minute, from: picker.date) < Constants.Values.Time.minutesUntilNotification ? calendar.component(.hour, from: picker.date) - Constants.one : calendar.component(.hour, from: picker.date)
            let triggerDate = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: Constants.Identifiers.checkInNotification, content: content, trigger: triggerDate)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let hasError = error {
                    let alert = UIAlertController(title: Constants.Error.notificationBookingError, message: hasError.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
        
        if options.workWeek == Constants.saturday {
            let week = Date.getWeekDays(workSaturday: options.workWeek == Constants.saturday)
            let content = UNMutableNotificationContent()
            content.title = Constants.Messages.CheckInNotification.title
            content.sound = UNNotificationSound.default()
            content.body = Constants.Messages.CheckInNotification.body
            var components = DateComponents()
            guard let saturday = week.last else { return }
            components.month = calendar.component(.weekOfMonth, from: saturday)
            components.day = calendar.component(.day, from: saturday)
            components.year = calendar.component(.year, from: saturday)
            components.minute = calendar.component(.minute, from: picker.date) < 15 ? 60 - calendar.component(.minute, from: picker.date) - 15 : calendar.component(.minute, from: picker.date) - 15
            components.hour = calendar.component(.minute, from: picker.date) < 15 ? calendar.component(.hour, from: picker.date) - 1 : calendar.component(.hour, from: picker.date)
            let triggerDate = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: Constants.Identifiers.checkInNotification, content: content, trigger: triggerDate)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let hasError = error {
                    let alert = UIAlertController(title: Constants.Error.notificationBookingError, message: hasError.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
    }

    
    func setupPickers() {
        if let safeUser = self.user, let options = safeUser.optionsOfUser {
            for index in 0...Constants.Options.optionsCount {
                switch index {
                case 0:
                    guard let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: Constants.Indices.section)) else { return }
                    guard let timePicker = cell.subviews[Constants.Indices.subviewPosition] as? UIDatePicker else { return }
                    guard let checkInTime = options.checkInTime else { return }
                    let checkInComponents = checkInTime.split(separator: Constants.separator)
                    var components = DateComponents()
                    let calendar = NSCalendar.current
                    components.hour = Int(checkInComponents[Constants.Indices.separatorHour])
                    components.minute = Int(checkInComponents[Constants.Indices.separatorMinute])
                    guard let date = calendar.date(from: components) else { return }
                    
                    timePicker.date = date
                case 1:
                    guard let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: Constants.Indices.section)) else { return }
                    guard let workWeekPicker = cell.subviews[Constants.Indices.subviewPosition] as? UIPickerView else { return }
                    let userOption = options.workWeek
                    let pickerIndex = Constants.Options.days.index { (day) -> Bool in
                        return day == userOption
                    }
                    if let index = pickerIndex {
                        workWeekPicker.selectRow(index, inComponent: Constants.Indices.pickerComponent, animated: false)
                    }
                case 2:
                    guard let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: Constants.Indices.section)) else { return }
                    guard let workWeekPicker = cell.subviews[Constants.Indices.subviewPosition] as? UIPickerView else { return }
                    let userOption = options.weekWorkHours
                    let pickerIndex = Constants.Options.hours.index { (hour) -> Bool in
                        return hour == userOption
                    }
                    if let index = pickerIndex {
                        workWeekPicker.selectRow(index, inComponent: Constants.Indices.pickerComponent, animated: false)
                    }
                default:
                    print(Constants.Error.beyondRange)
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
        return Constants.Values.TableView.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.optionsCell) else { return UITableViewCell(style: .default, reuseIdentifier: Constants.Identifiers.optionsCell) }
        switch indexPath.row {
        case 0:
            self.setupCellWithTimePicker(cell: cell, identifier: Constants.Identifiers.timePicker, message: Constants.Messages.Labels.hoursLabel, width: Constants.Values.Sizes.timeFrameWidth)
        case 1:
            self.setupCellWithPicker(cell: cell, identifier: Constants.Identifiers.dayPicker, message: Constants.Messages.Labels.weekLabel, width: Constants.Values.Sizes.weekFrameWidth)
        case 2:
            self.setupCellWithPicker(cell: cell, identifier: Constants.Identifiers.hoursPicker, message: Constants.Messages.Labels.hoursLabel, width: Constants.Values.Sizes.hoursFrameWidth)
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
        picker.locale = Locale(identifier: Constants.Locales.ptBR)
        
        let frame = CGRect(x: cell.frame.minX + Constants.Values.Sizes.distanceBetweenLabels, y: cell.frame.minY, width: cell.frame.width - Constants.Values.Sizes.timePickerWidth, height: cell.frame.height)
        let label = UILabel(frame: frame)
        label.text = message
        label.font = label.font.withSize(Constants.Values.Sizes.optionsFontSize)
        
        cell.addSubview(label)
        cell.addSubview(picker)
    }
    
    func setupCellWithPicker(cell: UITableViewCell, identifier: String, message: String, width: CGFloat) {
        let pickerFrame = CGRect(x: cell.frame.maxX - width , y: cell.frame.minY, width: width, height: cell.frame.height)
        let picker = UIPickerView(frame: pickerFrame)
        picker.accessibilityIdentifier = identifier
        picker.dataSource = self
        picker.delegate = self

        let frame = CGRect(x: cell.frame.minX + Constants.Values.Sizes.distanceBetweenLabels, y: cell.frame.minY, width: cell.frame.width - Constants.Values.Sizes.timePickerWidth, height: cell.frame.height)
        let label = UILabel(frame: frame)
        label.text = message
        label.font = label.font.withSize(Constants.Values.Sizes.optionsFontSize)

        cell.addSubview(label)
        cell.addSubview(picker)
    }
}

extension OptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Values.Sizes.tableViewHeight
    }
}

extension OptionsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.accessibilityIdentifier == Constants.Identifiers.timePicker {
            return Constants.Values.timeComponentsCount
        } else {
            return Constants.Values.defaultComponentsCount
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier {
        case Constants.Identifiers.dayPicker:
            return Constants.Options.days.count
        case Constants.Identifiers.hoursPicker:
            return Constants.Options.hours.count
        default:
            return Constants.zero
        }
    }
}

extension OptionsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case Constants.Identifiers.hoursPicker:
            return String(Constants.Options.hours[row])
        case Constants.Identifiers.dayPicker:
            return String(Constants.Options.days[row])
        default:
            return Constants.emptyString
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case Constants.Identifiers.dayPicker:
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
        case Constants.Identifiers.hoursPicker:
            if let user = self.user {
                if let options = user.optionsOfUser {
                    options.weekWorkHours = Int16(Constants.Options.hours[row])
                    user.updateWorkedHours()
                    user.updateHoursBank()
                    PersistenceService.saveContext()
                } else {
                    let options = Options(context: PersistenceService.context)
                    options.weekWorkHours = Int16(Constants.Options.hours[row])
                    user.optionsOfUser = options
                    PersistenceService.saveContext()
                }
            }
        default:
            print(Constants.Error.beyondRange)
        }
    }
}

extension OptionsViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}
