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
import FBSDKLoginKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: LoginView!
    public var userInfoDelegate: UserInfoDelegate?
    
    override func viewDidLoad() {
        Date.getMonthDays()
        self.loginView.setup()
    }
    
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
                if let safeIndex = index {
                    self.userInfoDelegate?.userInfo(user: users[safeIndex])
                    self.present(navigationController, animated: true)
                } else {
                    let user = self.createNewUserWithDefaultInfo(name: name)
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
    
    func createNewUserWithDefaultInfo(name: String) -> User {
        let user = User(context: PersistenceService.context)
        let option = Options(context: PersistenceService.context)
        option.checkInTime = "08:00"
        option.weekWorkHours = 40
        option.workWeek = "Sexta"
        user.name = name
        user.optionsOfUser = option
        user.dayWorkedHours = 0
        user.weekWorkedHours = 0
        PersistenceService.saveContext()
        return user
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
}
