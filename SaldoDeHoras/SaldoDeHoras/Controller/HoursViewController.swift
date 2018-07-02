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
        guard let paidHours = Int16(self.hoursView.payHoursTextField.text!) else { return }
        
        if paidHours <= user.weekWorkedHours {
            user.weekWorkedHours -= paidHours
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
