//
//  TYPinLock_UITests.swift
//  TYPinLock_UITests
//
//  Created by luckytianyiyan on 2018/1/12.
//  Copyright © 2018年 yinhun. All rights reserved.
//

import XCTest

class TYPinLock_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func inputPassCode(app: XCUIApplication, buttonIndex: Int) {
        let button1 = app.windows.firstMatch.buttons.element(boundBy: buttonIndex)
        button1.tap()
        button1.tap()
        button1.tap()
        button1.tap()
    }

    func testExample() {
        let app = XCUIApplication()
        app.buttons["Set Pin"].tap()
        snapshot("0SetPinEmpty")
        
        inputPassCode(app: app, buttonIndex: 0)
        snapshot("1SetPinInputed")
        app.buttons["Ok"].tap()
        
        snapshot("2SetPinConfirmEmpty")
        inputPassCode(app: app, buttonIndex: 0)
        snapshot("3SetPinConfirmInputed")
        app.buttons["Ok"].tap()
        
        app.buttons["Lock"].tap()
        snapshot("4LockEmpty")
        inputPassCode(app: app, buttonIndex: 1)
        snapshot("4LockInputed")
        app.buttons["Ok"].tap()
    }
    
}
