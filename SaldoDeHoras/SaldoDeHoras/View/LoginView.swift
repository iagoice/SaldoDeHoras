//
//  LoginView.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 21/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginView: UIView {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    func setup () {
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.publishPermissions = []
        fbLoginButton.center = CGPoint(x: self.center.x, y: self.center.y + Constants.Values.Sizes.fbLoginButtonCenterY)
        fbLoginButton.accessibilityIdentifier = "fbLoginButton"
        self.addSubview(fbLoginButton)
        self.backgroundColor = Constants.Colors.background
        self.loginButton.roundButton(value: Constants.Values.Round.view)
        self.loginButton.accessibilityIdentifier = "loginButton"
        self.userTextField.accessibilityIdentifier = "loginTextField"
    }
}
