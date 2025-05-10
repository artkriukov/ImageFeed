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
        loginTextField.typeText("")
        
        app.toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.secureTextFields.firstMatch
        passwordTextField.tap()
        
        let password = ""
        for char in password {
            passwordTextField.typeText(String(char))
            usleep(500_000)
        }
        
        webView.buttons["Login"].tap()
        
        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 1. Ожидание загрузки ленты
        let tablesQuery = app.tables
        let firstCell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 15), "Лента не загрузилась")
        
        // 2. Скролл
        firstCell.swipeUp()
        
        // 3. Лайк/дизлайк
        let cellToLike = tablesQuery.cells.element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 10), "Ячейка для лайка не найдена")
        
        let likeButton = cellToLike.buttons["like_button_off"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5), "Кнопка лайка не найдена")
        likeButton.tap()
        
        let likedButton = cellToLike.buttons["like_button_on"]
        XCTAssertTrue(likedButton.waitForExistence(timeout: 5), "Лайк не установился")
        likedButton.tap()
        
        // 4. Переход к детальному просмотру
        cellToLike.tap()
        
        // 5. Проверка детального экрана
        let image = app.scrollViews.images["fullscreen_image_view"]
        XCTAssertTrue(image.waitForExistence(timeout: 15), "Изображение не открылось")
        
        // 6. Возврат
        let backButton = app.buttons["nav_back_button_white"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 10), "Кнопка возврата не найдена")
        backButton.tap()
        
        // 7. Проверка возврата
        XCTAssertTrue(tablesQuery.element.waitForExistence(timeout: 10), "Не вернулись на ленту")
    }
}
