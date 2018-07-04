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
import FBSDKShareKit

class HomeView: UIView {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checksScrollView: UIScrollView!
    @IBOutlet weak var checksView: UIView!
    @IBOutlet weak var animationConstraint: NSLayoutConstraint!
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                let current = touch.location(in: self)
                let previous = touch.previousLocation(in: self)
                UIView.animate(withDuration: 0.3) {
                    if previous.y > current.y && self.animationConstraint.constant < 20 {
                        self.animationConstraint.constant += previous.y - current.y
                    }
                    if previous.y < current.y && self.animationConstraint.constant > -50 {
                        self.animationConstraint.constant -= current.y - previous.y
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                UIView.animate(withDuration: 0.3) {
                    var constant = self.animationConstraint.constant
                    if constant == 20 || constant == -50 {
                        constant = constant == 20 ? -50 : 20
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                let current = touch.location(in: self)
                let previous = touch.previousLocation(in: self)
                if current.y > previous.y {
                    if  self.animationConstraint.constant < 0 {
                        UIView.animate(withDuration: 0.5) {
                            self.animationConstraint.constant = -50
                        }
                    } else {
                        UIView.animate(withDuration: 0.5) {
                            self.animationConstraint.constant = 20
                        }
                    }
                } else {
                    if  self.animationConstraint.constant > -20 {
                        UIView.animate(withDuration: 0.5) {
                            self.animationConstraint.constant = 20
                        }
                    } else {
                        UIView.animate(withDuration: 0.5) {
                            self.animationConstraint.constant = -50
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                UIView.animate(withDuration: 1.0) {
                    if self.animationConstraint.constant != 20 && self.animationConstraint.constant != -50 {
                        let distanceTo20 = abs(20  - self.animationConstraint.constant)
                        let distanceTo50 = abs(-50 - self.animationConstraint.constant)
                        if distanceTo20 < distanceTo50 {
                            self.animationConstraint.constant = 20
                        } else {
                            self.animationConstraint.constant = -50
                        }
                    }
                }
            }
        }
    }
    
    func setup(user: User?) {
        self.checkButton.roundButton(value: 50.0)
        self.updateCheckLabels(user: user)
        self.addGestures()
        self.checksView.roundView(value: 5.0)
        self.checksScrollView.alwaysBounceHorizontal = false
        self.checksScrollView.bounces = false
        
        let shareLink = FBSDKShareLinkContent()
        shareLink.contentURL = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        shareLink.quote = "Estou usando Saldo de Horas para marcar meu ponto!"
        let shareButton = FBSDKShareButton()
        shareButton.shareContent = shareLink
        shareButton.center = CGPoint(x: self.center.x, y: self.center.y - 80)
        self.addSubview(shareButton)
    }
    
    func updateCheckLabels (user: User?) {
        self.removeCheckLabels()
        if let safeUser = user, let checks = safeUser.checksofuser {
            let sortedChecks = self.sortChecks(checks: checks)
            for (index, check) in sortedChecks.enumerated() {
                if let checkMark = check as? Check {
                    createCheckLabel(time: checkMark.date!, index: index)
                    self.checksScrollView.contentSize = CGSize(width: self.checksScrollView.contentSize.width + 110, height: self.checksScrollView.contentSize.height)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        label.text = formatter.string(from: time as Date)
        self.checksScrollView.addSubview(label)
        let x = self.checksScrollView.frame.minX + 100 * CGFloat(index) + (index == 0 ? 0 : 10*CGFloat(index))
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

