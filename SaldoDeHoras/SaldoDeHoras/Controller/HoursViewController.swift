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
    var user: User?
    
    @IBOutlet var hoursView: HoursView!
    
    override func viewDidLoad() {
        if let user = self.user, let options = user.optionsOfUser, let weekWorkHours = self.weekHours {
            self.weekHours = weekWorkHours - Int(options.weekWorkHours)
        }
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

extension HoursViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}
