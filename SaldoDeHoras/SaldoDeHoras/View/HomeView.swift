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
    
    let zero = CGFloat(Constants.zero)
    let two = CGFloat(Constants.two)
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checksScrollView: UIScrollView!
    @IBOutlet weak var checksView: UIView!
    @IBOutlet weak var animationConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var checksViewLabel: UILabel!
    
    func setup(user: User?) {
        self.backgroundColor = Constants.Colors.background
        self.updateCheckLabels(user: user)
        self.setupChecksView()
        self.setupButtons()
    }
    
    func updateCheckLabels (user: User?) {
        self.removeCheckLabels()
        if let safeUser = user, let checks = safeUser.checksofuser {
            let sortedChecks = safeUser.sortChecks(checks: checks)
            for (index, check) in sortedChecks.enumerated() {
                if let checkMark = check as? Check {
                    createCheckLabel(time: checkMark.date!, index: index)
                    self.checksScrollView.contentSize = CGSize(width: self.checksScrollView.contentSize.width + Constants.Values.Sizes.checkLabelWidth + Constants.Values.Sizes.checksAddDistance, height: self.checksScrollView.contentSize.height)
                }
            }
        }
    }
    
    func removeCheckLabels() {
        for view in self.checksScrollView.subviews {
            view.removeFromSuperview()
        }
        self.checksScrollView.contentSize.width = zero
    }
    
    func createCheckLabel(time: NSDate, index: Int) {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.Formats.timeFormat
        label.text = formatter.string(from: time as Date)
        self.checksScrollView.addSubview(label)
        let x = self.checksScrollView.frame.minX + Constants.Values.Sizes.checkLabelWidth * CGFloat(index) + (index == Constants.zero ? zero : Constants.Values.Sizes.checksAddDistance * CGFloat(index))
        label.frame = CGRect(x: x, y: self.checksScrollView.frame.minY - self.checksScrollView.frame.height/CGFloat(Constants.two), width: Constants.Values.Sizes.checkLabelWidth, height: self.checksScrollView.frame.height/two)
        label.textColor = UIColor.white
        label.backgroundColor = Constants.Colors.checkLabel
        label.roundLabel(label.frame.size.height/two)
        label.textAlignment = .center
    }

    // Setup ------------------------------------------------------------------
    
    func setupButtons() {
        self.setupCheckInButton()
        
        self.optionsButton.roundButton(value: Constants.Values.Round.smallButton)
        self.optionsButton.setImage(UIImage(named: Constants.Assets.options), for: .normal)
        self.optionsButton.backgroundColor = Constants.Colors.buttonBackground
        self.optionsButton.setTitleColor(Constants.Colors.buttonTitle, for: .normal)
        self.optionsLabel.textColor = Constants.Colors.labelText
        
        self.hoursButton.roundButton(value: Constants.Values.Round.smallButton)
        self.hoursButton.setImage(UIImage(named: Constants.Assets.hours), for: .normal)
        self.hoursButton.backgroundColor = Constants.Colors.buttonBackground
        self.hoursButton.setTitleColor(Constants.Colors.buttonTitle, for: .normal)
        self.hoursLabel.textColor = Constants.Colors.labelText
    }
    
    func setupCheckInButton() {
        let frame = CGRect(x: checkButton.frame.minX, y: checkButton.frame.minY, width: checkButton.frame.width/2, height: 10)
        let hourLabel = UILabel(frame: frame)
        hourLabel.text = "Teste"
        hourLabel.backgroundColor = UIColor.black
        checkButton.addSubview(hourLabel)
        
        hourLabel.topAnchor.constraint(equalTo: checkButton.topAnchor, constant: 10)
        
        self.checkButton.frame.size = CGSize(width: Constants.Values.Sizes.checkButtonWidth, height: Constants.Values.Sizes.checkButtonHeight)
        self.checkButton.roundButton(value: Constants.Values.Round.button)
        self.checkButton.backgroundColor = Constants.Colors.buttonBackground
        self.checkButton.setTitleColor(Constants.Colors.buttonTitle, for: .normal)
    }
    
    func setupChecksView (){
        self.checksView.roundView(value: Constants.Values.Round.view)
        self.checksScrollView.alwaysBounceHorizontal = false
        self.checksScrollView.bounces = false
        self.checksView.backgroundColor = Constants.Colors.checksView
        self.checksViewLabel.textColor = Constants.Colors.buttonTitle
        self.checksScrollView.layoutIfNeeded()
    }
    
    func setupFacebookButton () {
        let shareLink = FBSDKShareLinkContent()
        shareLink.contentURL = URL(string: Constants.Messages.Facebook.rickRoll)
        shareLink.quote = Constants.Messages.Facebook.shareMessage
        let shareButton = FBSDKShareButton()
        shareButton.shareContent = shareLink
        shareButton.center = CGPoint(x: self.center.x, y: self.center.y - Constants.Values.Sizes.fbShareButtonCenterY)
        self.addSubview(shareButton)
    }
}

extension HomeView {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                let current = touch.location(in: self)
                let previous = touch.previousLocation(in: self)
                UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
                    if previous.y > current.y && self.animationConstraint.constant < Constants.Values.Constraint.higherConstraint {
                        self.animationConstraint.constant += previous.y - current.y
                    }
                    if previous.y < current.y && self.animationConstraint.constant > Constants.Values.Constraint.lowerConstraint {
                        self.animationConstraint.constant -= current.y - previous.y
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
                    var constant = self.animationConstraint.constant
                    if constant == Constants.Values.Constraint.higherConstraint || constant == Constants.Values.Constraint.lowerConstraint {
                        constant = constant == Constants.Values.Constraint.higherConstraint ? Constants.Values.Constraint.lowerConstraint : Constants.Values.Constraint.higherConstraint
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
                    if  !self.animationConstraint.constant.isPositive() {
                        UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
                            self.animationConstraint.constant = Constants.Values.Constraint.lowerConstraint
                            self.layoutIfNeeded()
                        }
                    } else {
                        UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
                            self.animationConstraint.constant = Constants.Values.Constraint.higherConstraint
                            self.layoutIfNeeded()
                        }
                    }
                } else {
                    if  self.animationConstraint.constant > Constants.Values.ChecksView.snapThreshold {
                        UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
                            self.animationConstraint.constant = Constants.Values.Constraint.higherConstraint
                            self.layoutIfNeeded()
                        }
                    } else {
                        UIView.animate(withDuration: Constants.Values.AnimationDuration.short) {
                            self.animationConstraint.constant = Constants.Values.Constraint.lowerConstraint
                            self.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch.view == checksView {
                UIView.animate(withDuration: Constants.Values.AnimationDuration.long) {
                    if self.animationConstraint.constant != Constants.Values.Constraint.higherConstraint && self.animationConstraint.constant != Constants.Values.Constraint.lowerConstraint {
                        let distanceTo20 = abs(Constants.Values.Constraint.higherConstraint  - self.animationConstraint.constant)
                        let distanceTo50 = abs(Constants.Values.Constraint.lowerConstraint - self.animationConstraint.constant)
                        if distanceTo20 < distanceTo50 {
                            self.animationConstraint.constant = Constants.Values.Constraint.higherConstraint
                        } else {
                            self.animationConstraint.constant = Constants.Values.Constraint.lowerConstraint
                        }
                    }
                }
            }
        }
    }
}

