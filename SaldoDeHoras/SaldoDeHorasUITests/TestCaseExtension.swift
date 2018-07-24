//
//  TestCaseExtension.swift
//  SaldoDeHorasUITests
//
//  Created by Iago Mordente Rezende Leão Corrêa on 24/07/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import UIKit
import XCTest

// MARK: - XCTestCase extension
extension XCTestCase {
    
    /// Wait an element exists to start interact with it.
    ///
    /// - Parameters:
    ///   - element: Current element
    ///   - timeout: Optional timeout. Default value is 3 seconds.
    func waitElementExists(element: XCUIElement, timeout: TimeInterval = 5) {
        let exists = NSPredicate(format: "exists == 1")
        
        expectation(for: exists, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
