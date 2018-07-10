//
//  HoursView.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 27/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit

class HoursView: UIView {
    
    @IBOutlet weak var dayHoursLabel: UILabel!
    @IBOutlet weak var weekHoursLabel: UILabel!
    @IBOutlet weak var payHoursTextField: UITextField!
    @IBOutlet weak var hoursBank: UILabel!
    @IBOutlet weak var paidHoursLabel: UILabel!
    @IBOutlet weak var weekHours: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    func setup (withUser user: User?) {
        let today = Date()
        self.dayHoursLabel.text  = user != nil ? "\(user!.calculateDayWorkedHoursSoFar(date: today)) horas" : "0"
        self.weekHoursLabel.text = user != nil ? "\(user!.weekWorkedHours) horas" : "0"
        self.hoursBank.text  = user != nil ? "\(user!.hoursBank) horas" : ""
        self.paidHoursLabel.text = user != nil ? "Horas pagas: \(user!.paidHours)" : ""
        self.weekHours.text = user != nil ? "\(user!.weekWorkedHours - user!.optionsOfUser!.weekWorkHours) horas" : "0"
        
        self.dayHoursLabel.textColor = Constants.Colors.buttonBackground
        self.weekHoursLabel.textColor = Constants.Colors.buttonBackground
        self.hoursBank.textColor = Constants.Colors.buttonBackground
        self.paidHoursLabel.textColor = Constants.Colors.buttonBackground
        self.weekHours.textColor = Constants.Colors.buttonBackground
        
        self.payButton.roundButton(value: Constants.Values.Round.view)
        
        self.backgroundColor = Constants.Colors.background
    }
}
