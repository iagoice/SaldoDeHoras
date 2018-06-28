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
    @IBOutlet weak var checksScrollView: UIScrollView!
    @IBOutlet weak var checksView: UIView!
    @IBOutlet weak var animationConstraint: NSLayoutConstraint!
    
    func setup(user: User?) {
        self.checkButton.roundButton(value: 50.0)
        self.updateCheckLabels(user: user)
        self.addGestures()
        self.backgroundColor = UIColor.orange
        
    }
    
    func updateCheckLabels (user: User?) {
        self.removeCheckLabels()
        if let safeUser = user, let checks = safeUser.checksofuser {
            let sortedChecks = self.sortChecks(checks: checks)
            for (index, check) in sortedChecks.enumerated() {
                if let checkMark = check as? Check {
                    createCheckLabel(time: checkMark.date!, index: index)
                    self.checksScrollView.contentSize = CGSize(width: self.checksScrollView.contentSize.width + 100, height: self.checksScrollView.contentSize.height)
                }
            }
        }
    }
    
    func removeCheckLabels() {
        for view in self.checksScrollView.subviews {
            view.removeFromSuperview()
        }
        self.checksScrollView.contentSize.width = 0
    }
    
    func createCheckLabel(time: NSDate, index: Int) {
        let label = UILabel()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: time as Date)
        let minute = calendar.component(.minute, from: time as Date)
        label.text = "\(hour):\(minute)"
        self.checksScrollView.addSubview(label)
        let x = self.checksScrollView.frame.minX + 100 * CGFloat(index) + 10*CGFloat(index)
        label.frame = CGRect(x: x, y: self.checksScrollView.frame.minY - self.checksScrollView.frame.height/2, width: 100, height: self.checksScrollView.frame.height/2)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.roundLabel(label.frame.size.height/2)
        label.textAlignment = .center
    }
    
    func addGestures() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self.checksView, action: #selector(swipeUp))
        swipeUpGesture.direction = .up
        let tapGesture = UIGestureRecognizer(target: self.checksView, action: #selector(swipeUp))
        self.checksView.addGestureRecognizer(swipeUpGesture)
        self.checksView.addGestureRecognizer(tapGesture)
        for view in self.checksView.subviews {
            if view is UILabel {
                view.addGestureRecognizer(swipeUpGesture)
                view.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc func swipeUp () {
        UIView.animate(withDuration: 1.0) {
            let constraint = self.checksView.constraints.filter { (constraintIn) -> Bool in
                return constraintIn.identifier == "swipeConstraint"
                }.first
            constraint?.constant = 20
            self.layoutIfNeeded()
        }
    }
    
    func sortChecks (checks: NSSet) -> [Any] {
        let todayChecks = checks.filter { (check) -> Bool in
            if let checkDate = check as? Check {
                return Date.isCheckFromToday(check: checkDate)
            }
            return false
        }
        
        let sortedChecks = todayChecks.sorted { (firstDate, secondDate) -> Bool in
            guard let first  = firstDate  as? Check else { return false }
            guard let second = secondDate as? Check else { return false }
            return first.date!.compare(second.date! as Date) == .orderedAscending
        }
        
        return sortedChecks
    }
}

