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
            usleep(500_000)
        }
        
        webView.buttons["Login"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
//    func testFeed() throws {
//        let app = XCUIApplication()
//        app.launch()
//        
//        // 1. Ожидание загрузки ленты
//        let tablesQuery = app.tables
//        let firstCell = tablesQuery.cells.element(boundBy: 0)
//        XCTAssertTrue(firstCell.waitForExistence(timeout: 15), "Лента не загрузилась")
//        
//        // 2. Скролл с проверкой
//        firstCell.swipeUp()
//        usleep(500_000)
//        
//        // 3. Получение ячейки
//        let cellToLike = tablesQuery.cells.element(boundBy: 1)
//        
//        // Явная проверка видимости ячейки
//        if !cellToLike.isHittable {
//            tablesQuery.element.swipeUp()
//        }
//        XCTAssertTrue(cellToLike.waitForExistence(timeout: 10), "Ячейка для лайка не найдена")
//        
//        // 4. Работа с кнопкой лайка
//        let likeButton = cellToLike.buttons["like_button_off"]
//        
//        // Решение проблемы с hit point:
//        let coordinate = likeButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
//        coordinate.tap()
//        
//        // Альтернативный вариант:
//        // cellToLike.tap() // Если кнопка занимает всю ячейку
//        
//        // 5. Проверка изменения состояния
//        let likedButton = cellToLike.buttons["like_button_on"]
//        XCTAssertTrue(likedButton.waitForExistence(timeout: 5), "Лайк не установился")
//        
//        // 6. Возврат
//        let backButton = app.buttons["nav_back_button_white"]
//        XCTAssertTrue(backButton.waitForExistence(timeout: 10), "Кнопка возврата не найдена")
//        backButton.tap()
//        
//        // 7. Проверка возврата
//        XCTAssertTrue(tablesQuery.element.waitForExistence(timeout: 10), "Не вернулись на ленту")
//    }
    
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
