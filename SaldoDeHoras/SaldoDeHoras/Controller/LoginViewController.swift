//
//  LoginViewController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 21/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: LoginView!
    
    private var emptyAlert: UIAlertController = {
        let alert = UIAlertController(title: "Preencha o campo usuário", message: "Campo usuário não pode estar vazio.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }()
    private var index: Int?
    private var users: [User]?
    
    @IBAction func pressLogin(_ sender: Any) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            self.users = try PersistenceService.context.fetch(fetchRequest)
            guard let name = loginView.userTextField.text else { return }
            if !name.isEmpty {
                self.index = users!.index(where: { (user) -> Bool in
                    return user.name! == name
                })
                if self.index != nil {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                } else {
                    let user = User(context: PersistenceService.context)
                    user.name = name
                    PersistenceService.saveContext()
                    self.index = users!.count
                    self.users = try PersistenceService.context.fetch(fetchRequest)
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
            } else {
                self.present(emptyAlert, animated: true)
            }
        } catch {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? HomeViewController {
            if let safeUsers = users, let safeIndex = index {
                destination.user = safeUsers[safeIndex]
                destination.index = safeIndex
            }
        }
    }
}
