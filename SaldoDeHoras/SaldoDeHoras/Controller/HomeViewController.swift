//
//  ViewController.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 20/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeView: HomeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeView.setup()
    }
    
    @IBAction func checkIn(sender: Any) {
        
    }
}

