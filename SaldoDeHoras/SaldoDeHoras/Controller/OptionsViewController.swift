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

class OptionsViewController: UIViewController {
    var user: User?
    var hours = [20, 30, 40, 44]
    var days = ["Sexta", "Sábado"]
    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupPickers()
    }
    
    func setupPickers() {
        if let safeUser = self.user, let options = safeUser.optionsOfUser {
            for index in 0...2 {
                switch index {
                case 0:
                    let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: 0))
                    let timePicker = cell?.subviews[3] as! UIDatePicker
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm"
                    let date = formatter.date(from: options.checkInTime!)
                    timePicker.date = date!
                case 1:
                    let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: 0))
                    let workWeekPicker = cell?.subviews[3] as! UIPickerView
                    let userOption = options.workWeek
                    let pickerIndex = days.index { (day) -> Bool in
                        return day == userOption
                    }
                    workWeekPicker.selectRow(pickerIndex!, inComponent: 0, animated: false)
                case 2:
                    let cell = self.optionsTableView.cellForRow(at: IndexPath(row: index, section: 0))
                    let workWeekPicker = cell?.subviews[3] as! UIPickerView
                    let userOption = options.weekWorkHours
                    let pickerIndex = hours.index { (hour) -> Bool in
                        return hour == userOption
                    }
                    workWeekPicker.selectRow(pickerIndex!, inComponent: 0, animated: false)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        switch indexPath.row {
        case 0:
            self.setupCellWithTimePicker(cell: cell!, identifier: "time", message: "Hora de entrada: ", width: 100)
        case 1:
            self.setupCellWithPicker(cell: cell!, identifier: "days", message: "Semana até dia: ", width: 120)
        case 2:
            self.setupCellWithPicker(cell: cell!, identifier: "hours", message: "Duração semanal da jornada: ", width: 50)
        default:
            print()
        }
        return cell!
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
            return self.days.count
        case "hours":
            return self.hours.count
        default:
            return 0
        }
    }
}

extension OptionsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier {
        case "hours":
            return String(hours[row])
        case "days":
            return String(days[row])
        default:
            return ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.accessibilityIdentifier {
        case "days":
            if let safeUser = self.user, let option = safeUser.optionsOfUser {
                option.workWeek = days[row]
                PersistenceService.saveContext()
            } else {
                let option = Options(context: PersistenceService.context)
                option.workWeek = days[row]
                self.user!.optionsOfUser = option
                PersistenceService.saveContext()
            }
        case "hours":
            if let option = self.user!.optionsOfUser {
                option.weekWorkHours = Int16(hours[row])
                PersistenceService.saveContext()
            } else {
                let option = Options(context: PersistenceService.context)
                option.weekWorkHours = Int16(hours[row])
                self.user!.optionsOfUser = option
                PersistenceService.saveContext()
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
