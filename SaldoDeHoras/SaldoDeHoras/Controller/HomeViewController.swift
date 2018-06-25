//
//  ViewController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 20/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeView: HomeView!
    public var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeView.setup(user: user)
    }
    
    @IBAction func checkIn(sender: Any) {
        let today = Date()
        if let safeUser = self.user {
            let todayDate = today as NSDate
            let check = Check(context: PersistenceService.context)
            check.date = todayDate
            safeUser.addToChecksofuser(check)
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: user)
        }
    }
    
    @IBAction func animate(_ sender: UIButton) {
        let constraint = self.homeView.animationConstraint
        UIView.animate(withDuration: 0.5) {
            constraint!.constant = constraint!.constant == 20 ? -70 : 20
            self.homeView.layoutIfNeeded()
        }
    }
    
    @IBAction func resetCoreData(_ sender: UIButton) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceService.context.execute(deleteRequest)
            try PersistenceService.context.save()
        } catch {}
    }
}

extension HomeViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}

