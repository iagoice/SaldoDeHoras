//
//  SaldoDeHorasUITests.swift
//  SaldoDeHorasUITests
//
//  Created by Iago Mordente Rezende Leão Corrêa on 20/06/18.
//  Copyright © 2018 Iago Mordente Rezende Leão Corrêa. All rights reserved.
//

import XCTest

class SaldoDeHorasUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

    }
    
    func testLogin() {
        let app = XCUIApplication()
        let loginButton = app.buttons["loginButton"]
        let textField = app.textFields["loginTextField"]
        let fbLoginButton = app.buttons["fbLoginButton"]
        
        waitElementExists(element: loginButton)
        waitElementExists(element: textField)
        waitElementExists(element: fbLoginButton)
        
        textField.tap()
        textField.typeText("iago")
        loginButton.tap()
    }
}
