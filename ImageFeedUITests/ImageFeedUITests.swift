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
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        XCTAssertTrue(tablesQuery.element.waitForExistence(timeout: 10), "Лента не загрузилась")
                
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        XCTAssertTrue(cellToLike.images.firstMatch.waitForExistence(timeout: 5), "Изображение не загрузилось")
        XCTAssertTrue(cellToLike.staticTexts.firstMatch.exists, "Дата не отображается")
        
        let likeButton = cellToLike.buttons["like_button_off"]
        let likedButton = cellToLike.buttons["like_button_on"]
        
        likeButton.tap()
        sleep(5)
        XCTAssertTrue(likedButton.exists, "Лайк не активировался")
        
        likedButton.tap()
        sleep(5)
        XCTAssertTrue(likeButton.exists, "Дизлайк не сработал")
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5), "Изображение не открылось")
        
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(1)
        
        app.buttons["nav_back_button_white"].tap()
        XCTAssertTrue(tablesQuery.element.exists, "Не вернулись в ленту")
    }
    
    func testProfile() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["profile_tab_button"].tap()
        
        XCTAssertTrue(app.staticTexts["profile_name_label"].exists)
        XCTAssertTrue(app.staticTexts["profile_login_label"].exists)
        
        app.buttons["logout_button"].tap()
        
        let alert = app.alerts["logout_alert"]
        XCTAssertTrue(alert.exists)
        
        alert.buttons["logout_confirm_button"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}

extension XCUIElement {
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        }
    }
    
    func safeTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate = self.coordinate(
                withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)
            )
            coordinate.tap()
        }
    }
}
