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
    var user: User?
    
    @IBOutlet var hoursView: HoursView!
    
    override func viewDidLoad() {
        guard let user = self.user else { return }
        self.hoursView.setup(withUser: user)
        self.setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: Constants.backButton, style: .plain, target: self, action: #selector(popViewController))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @objc func popViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payHours(_ sender: UIButton) {
        guard let user = self.user else { return }
        guard let paidHours = Int16(self.hoursView.payHoursTextField.text!) else {
            let invalidAlert = UIAlertController(title: Constants.Messages.HoursAlert.invalidHoursTitle, message: Constants.Messages.HoursAlert.invalidHoursMessage, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: Constants.Messages.okButton, style: .default) { (action) in
                invalidAlert.dismiss(animated: true, completion: nil)
                self.hoursView.setup(withUser: user)
            }
            invalidAlert.addAction(dismissAction)
            self.present(invalidAlert, animated: true)
            return
        }
        
        if paidHours <= user.hoursBank && paidHours.isPositive() {
            user.paidHours += paidHours
            user.hoursBank -= paidHours
            PersistenceService.saveContext()
            self.hoursView.payHoursTextField.text = Constants.emptyString
            let alertSuccess = UIAlertController(title: Constants.Messages.HoursAlert.successTitle, message: Constants.Messages.HoursAlert.successMessage, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: Constants.Messages.okButton, style: .default) { (action) in
                alertSuccess.dismiss(animated: true, completion: nil)
                self.hoursView.setup(withUser: user)
            }
            alertSuccess.addAction(dismissAction)
            self.present(alertSuccess, animated: true)
        } else {
            let alertFail = UIAlertController(title: Constants.Messages.HoursAlert.invalidHoursTitle, message: Constants.Messages.HoursAlert.invalidHoursBank, preferredStyle: .alert)
            if !paidHours.isPositive() {
                alertFail.message = Constants.Messages.HoursAlert.invalidHoursMessage
            }
            let dismissAction = UIAlertAction(title: Constants.Messages.okButton, style: .default) { (action) in
                alertFail.dismiss(animated: true, completion: nil)
            }
            alertFail.addAction(dismissAction)
            self.present(alertFail, animated: true)
        }
        
    }
}

extension HoursViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}
