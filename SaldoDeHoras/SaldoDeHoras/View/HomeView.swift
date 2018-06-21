//
//  HomeView.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 21/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HomeView: UIView {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checksView: UIStackView!
    
    var user: User?
    
    func setup() {
        self.checkButton.roundButton(value: 50.0)
        if let safeUser = self.user, let times = safeUser.checks {
            for time in times {
                let label = UILabel()
                let calendar = NSCalendar.current
                let hour = calendar.component(.hour, from: time as Date)
                label.text = String(hour)
                self.checksView.addArrangedSubview(label)
            }
        }
    }
}
