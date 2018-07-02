//
//  UIViewExtension.swift
//  SaldoDeHoras
//
//  Created by Iago Mordente Rezende Leão Corrêa on 29/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit

extension UIView {
    func roundView(value: CGFloat) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
    }
}
