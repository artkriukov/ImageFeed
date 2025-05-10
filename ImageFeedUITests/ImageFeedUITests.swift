//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Artem Kriukov on 09.05.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    func testAuth() throws {
        let app = XCUIApplication()
        app.launch()
        
        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
        authButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.textFields.firstMatch
        loginTextField.tap()
        loginTextField.typeText("art.kriukov@gmail.com")
        
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.secureTextFields.firstMatch
        passwordTextField.tap()
        
        let password = "Telefon11/"
        for char in password {
            passwordTextField.typeText(String(char))
            usleep(500_000) // 500ms задержка
        }
        
        webView.buttons["Login"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button off"].tap()
        cellToLike.buttons["like button on"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    } 
}
