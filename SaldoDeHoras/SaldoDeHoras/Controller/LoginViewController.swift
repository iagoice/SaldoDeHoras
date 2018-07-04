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
        self.loginView.setup()
    }
    
    private var emptyAlert: UIAlertController = {
        let alert = UIAlertController(title: Constants.Messages.LoginAlert.loginAlertTitle, message: Constants.Messages.LoginAlert.loginAlertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: Constants.Messages.LoginAlert.alertOKButton, style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }()
    
    @IBAction func pressLogin(_ sender: Any) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let storyboard = UIStoryboard(name: Constants.Storyboards.main, bundle: nil)
        var users: [User]
        var index: Int?
        
        do {
            users = try PersistenceService.context.fetch(fetchRequest)
            guard let name = loginView.userTextField.text else { return }
            if !name.isEmpty {
                index = users.index(where: { (user) -> Bool in
                    if let userName = user.name {
                        return userName == name
                    }
                    return false
                })
                guard let navigationController = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.navigationController) as? NavigationController else { return }
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entities.user)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceService.context.execute(deleteRequest)
            PersistenceService.saveContext()
        } catch {}
    }
    
    func createNewUserWithDefaultInfo(name: String) -> User {
        let user = User(context: PersistenceService.context)
        let option = Options(context: PersistenceService.context)
        option.checkInTime = Constants.DefaultValues.checkInTime
        option.weekWorkHours = Constants.DefaultValues.weekWorkHours
        option.workWeek = Constants.DefaultValues.workWeek
        user.name = name
        user.optionsOfUser = option
        user.dayWorkedHours = Constants.DefaultValues.workedHours
        user.weekWorkedHours = Constants.DefaultValues.weekWorkHours
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
