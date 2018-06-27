//
//  HoursViewController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 26/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation
import UIKit

class HoursViewController: UIViewController {
    var weekHours: Int?
    var dayHours: Int?

    @IBOutlet var hoursView: HoursView!
    
    override func viewDidLoad() {
        self.hoursView.setup(dayHours: self.dayHours, weekHours: self.weekHours)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension HoursViewController: HoursDelegate {
    func getHours(dayHours: Int?, weekHours: Int?) {
        if let safeHours = dayHours {
            self.dayHours = safeHours
        }
        
        if let safeHours = weekHours {
            self.weekHours = safeHours
        }
    }
}
