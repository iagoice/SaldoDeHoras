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
    
    func setup (dayHours: Int?, weekHours: Int?) {
        self.dayHoursLabel.text = dayHours != nil ? "\(dayHours!) horas" : ""
        self.weekHoursLabel.text = weekHours != nil ? "\(weekHours!) horas" : ""
    }
}
