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
    
    @IBOutlet weak var homeView: HomeView! {
        didSet {
            if let safeUser = self.user, let safeChecks = safeUser.checksofuser {
                self.hoursDelegate = self.homeView
//                let hours = self.calculateHours()
//                self.hoursDelegate.getHours(hours: hours)
            }
        }
    }
    
    public var user: User?
    public var hoursDelegate: HoursDelegate!
    public var userDelegate: UserInfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hoursDelegate = self.homeView
        self.homeView.setup(user: user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Check")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceService.context.execute(deleteRequest)
            PersistenceService.saveContext()
            self.homeView.updateCheckLabels(user: self.user)
        } catch {}
    }
    
    @IBAction func openOptions(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsViewController = storyboard.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        self.userDelegate = optionsViewController
        if let safeUser = self.user {
            self.userDelegate?.userInfo(user: safeUser)
        }
        self.navigationController?.pushViewController(optionsViewController, animated: true)
    }
    //    func calculateHours() -> Double {
//        let calendar = NSCalendar(calendarIdentifier: .gregorian)
//        var resultingHours: Double = 0
//        if let safeUser = self.user, let checks = safeUser.checksofuser {
//            let sortedChecks = self.homeView.sortChecks(checks: checks)
//            print("lul")
//        }
//        return resultingHours
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//
//        }
//    }
}

extension HomeViewController: UserInfoDelegate {
    func userInfo(user: User) {
        self.user = user
    }
}

