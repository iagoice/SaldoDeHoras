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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func payHours(_ sender: UIButton) {
        guard let user = self.user else { return }
        guard let paidHours = Int16(self.hoursView.payHoursTextField.text!) else {
            let invalidAlert = UIAlertController(title: "Horas inválidas", message: "Entre com um valor válido de horas", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                invalidAlert.dismiss(animated: true, completion: nil)
                self.hoursView.setup(withUser: user)
            }
            invalidAlert.addAction(dismissAction)
            self.present(invalidAlert, animated: true)
            return
        }
        
        if paidHours <= user.hoursBank && paidHours > 0 {
            user.paidHours += paidHours
            user.updateWorkedHours()
            PersistenceService.saveContext()
            self.hoursView.payHoursTextField.text = ""
            let alertSuccess = UIAlertController(title: "Horas pagas", message: "Horas pagas com sucesso.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
                alertSuccess.dismiss(animated: true, completion: nil)
                self.hoursView.setup(withUser: user)
            }
            alertSuccess.addAction(dismissAction)
            self.present(alertSuccess, animated: true)
        } else {
            let alertFail = UIAlertController(title: "Horas inválidas", message: "Você está tentando pagar horas além das que você trabalhou.", preferredStyle: .alert)
            if paidHours <= 0 {
                alertFail.message = "Entre com um valor válido de horas"
            }
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action) in
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
