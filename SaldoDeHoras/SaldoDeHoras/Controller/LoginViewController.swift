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
                let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! NavigationController
                self.userInfoDelegate = navigationController
                if index != nil {
                    self.userInfoDelegate?.userInfo(user: users[index!])
                    self.present(navigationController, animated: true)
                } else {
                    let user = User(context: PersistenceService.context)
                    let option = Options(context: PersistenceService.context)
                    option.checkInTime = "08:00"
                    option.weekWorkHours = 40
                    option.workWeek = "Sexta"
                    user.name = name
                    user.optionsOfUser = option
                    PersistenceService.saveContext()
                    index = users.count
                    self.userInfoDelegate?.userInfo(user: user)
                    self.present(navigationController, animated: true)
                }
            } else {
                self.present(emptyAlert, animated: true)
            }
        } catch {}
    }

    @IBAction func resetUsers(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceService.context.execute(deleteRequest)
            PersistenceService.saveContext()
        } catch {}
    }
}
