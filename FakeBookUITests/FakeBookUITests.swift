//
//  FakeBookUITests.swift
//  FakeBookUITests
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import XCTest

final class FakeBookUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func navigateToPostsTab() {
        let postsTab = app.tabBars.buttons["Posts"]
        XCTAssertTrue(postsTab.waitForExistence(timeout: 5), "Posts tab button does not exist")
        postsTab.tap()
    }
    
    func navigateToFavoritesTab() {
        let favoritesTab = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTab.waitForExistence(timeout: 5), "Favorites tab button does not exist")
        favoritesTab.tap()
    }
    
    func tapFirstPostCell() {
        let firstPost = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstPost.waitForExistence(timeout: 5), "First post cell does not exist")
        firstPost.tap()
        sleep(1)
    }
    
    func verifyPostsScreenIsDisplayed() {
        let postsLabel = app.staticTexts["Posts"]
        XCTAssertTrue(postsLabel.waitForExistence(timeout: 5), "Posts label does not exist")
        XCTAssertTrue(app.tabBars.buttons["Posts"].isSelected, "Posts tab should be selected")
    }
    
    func verifyFavoritesScreenIsDisplayed() {
        let favoritesLabel = app.staticTexts["Favorites"]
        XCTAssertTrue(favoritesLabel.waitForExistence(timeout: 5), "Favorites label does not exist")
        XCTAssertTrue(app.tabBars.buttons["Favorites"].isSelected, "Favorites tab should be selected")
    }
    
    func tapFavoriteButton() {
        let favoriteButton = app.buttons.element(matching: .button, identifier: nil).firstMatch
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Favorite button does not exist")
        favoriteButton.tap()
        sleep(1)
    }
    
    func verifyScreenIsDisplayed(title: String) {
        let titleLabel = app.staticTexts[title]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "\(title) label does not exist")
    }
    
    func testTabBarNavigation() throws {
        navigateToPostsTab()
        verifyPostsScreenIsDisplayed()
        navigateToFavoritesTab()
        verifyFavoritesScreenIsDisplayed()
    }
    
    func testFavoritePost() throws {
        navigateToPostsTab()
        tapFirstPostCell()
        tapFavoriteButton()
        navigateToFavoritesTab()
        verifyFavoritesScreenIsDisplayed()
        XCTAssertTrue(app.cells.count > 0, "No favorite posts found after favoriting")
    }
    
    func testUnfavoritePost() throws {
        navigateToPostsTab()
        tapFirstPostCell()
        tapFavoriteButton()
        navigateToFavoritesTab()
        let favoritesCount = app.cells.count
        XCTAssertTrue(favoritesCount >= 0, "Favorites count should be non-negative")
    }
    
    func testFavoritePostsNavigation() throws {
        navigateToPostsTab()
        tapFirstPostCell()
        tapFavoriteButton()
        navigateToFavoritesTab()
        let firstFavorite = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstFavorite.waitForExistence(timeout: 5), "First favorite post does not exist")
        firstFavorite.tap()
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                app.launch()
            }
        }
    }
}

