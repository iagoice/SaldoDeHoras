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
    
    func setup (withUser user: User?) {
        let today = Date()
        self.dayHoursLabel.text  = user != nil ? "\(user!.dayWorkedHours) horas" : "0"
        self.weekHoursLabel.text = user != nil ? "\(user!.weekWorkedHours) horas"           : "0"
    }
}
