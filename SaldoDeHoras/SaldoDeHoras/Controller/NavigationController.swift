//
//  NavigationController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 26/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NavigationController: UserInfoDelegate {
    func userInfo(user: User) {
        if let homeViewController = self.viewControllers[Constants.Indices.navigationController] as? HomeViewController{
            homeViewController.user = user
        }
    }
}
