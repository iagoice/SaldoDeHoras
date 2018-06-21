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
    
    @IBAction func pressLogin(_ sender: Any) {
        let users: [User]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            users = try PersistenceService.context.fetch(fetchRequest)
            guard let name = loginView.userTextField.text else { return }
            if !name.isEmpty {
                if users.contains(where: { (user) -> Bool in
                    return user.name == name
                }) {
                    self.presentHome(users: users, storyboard: storyboard, name: name)
                } else {
                    let user = User(context: PersistenceService.context)
                    user.name = name
                    PersistenceService.saveContext()
                    self.presentHome(users: users, storyboard: storyboard, name: name)
                }
            } else {
                self.present(emptyAlert, animated: true)
            }
        } catch {}
    }
    
    func presentHome(users: [User], storyboard: UIStoryboard, name: String) {
        let index = users.index(where: { (user) -> Bool in
            return user.name! == name
        })!
        
        if let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                homeViewController.homeView.user = users[index]
            self.present(homeViewController, animated: true)
        }
    }
}
