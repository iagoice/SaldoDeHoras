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
    @IBOutlet weak var checksView: UIScrollView!
    
    func setup(user: User?) {
        self.checkButton.roundButton(value: 50.0)
        if let safeUser = user, let times = safeUser.checks {
//            for(index, time) in times.enumerated() {
//                createCheckLabel(time: time, index: index)
//            }
        }
    }
    
    func updateCheckLabels (user: User?) {
        self.removeCheckLabels()
        if let safeUser = user, let checks = safeUser.checksofuser {
            for (index, check) in checks.enumerated() {
                if let checkMark = check as? Check {
                    createCheckLabel(time: checkMark.date!, index: index)
                }
            }
        }
    }
    
    func removeCheckLabels() {
        for view in self.checksView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func createCheckLabel(time: NSDate, index: Int) {
        let label = UILabel()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: time as Date)
        let minute = calendar.component(.minute, from: time as Date)
        label.text = "\(hour):\(minute)"
        self.checksView.addSubview(label)
        let x = self.checksView.frame.minX + 100 * CGFloat(index)
        label.frame = CGRect(x: x, y: self.checksView.frame.midY, width: 100, height: self.checksView.frame.height)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.roundView(40)
    }
}
