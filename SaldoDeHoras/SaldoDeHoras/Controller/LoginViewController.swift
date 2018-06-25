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
    public var userInfoDelegate: UserInfoDelegate?
    
    private var emptyAlert: UIAlertController = {
        let alert = UIAlertController(title: "Preencha o campo usuário", message: "Campo usuário não pode estar vazio.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }()
    
    @IBAction func pressLogin(_ sender: Any) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var users: [User]
        var index: Int?
        
        do {
            users = try PersistenceService.context.fetch(fetchRequest)
            guard let name = loginView.userTextField.text else { return }
            if !name.isEmpty {
                index = users.index(where: { (user) -> Bool in
                    return user.name! == name
                })
                let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.userInfoDelegate = homeViewController
                if index != nil {
                    self.userInfoDelegate?.userInfo(user: users[index!])
                    self.present(homeViewController, animated: true)
                } else {
                    let user = User(context: PersistenceService.context)
                    user.name = name
                    PersistenceService.saveContext()
                    index = users.count
                    self.userInfoDelegate?.userInfo(user: user)
                    self.present(homeViewController, animated: true)
                }
            } else {
                self.present(emptyAlert, animated: true)
            }
        } catch {}
    }
}
