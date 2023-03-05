// MoviesMVVMUITests.swift
// Copyright © Oleg Yakovlev All rights reserved.

import XCTest

/// Tестирование интерфейса и UI элементов
final class MoviesMVPUITests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let enterInApp = ""
        static let buttonOk = "OK"
        static let filmString = "0.0"
        static let navigationBarName = ""
        static let backButtonName = ""
        static let topFilms = ""
        static let showTiser = "Показать тизер"
        static let homeIdentifierString = "homeViewController"
        static let detailIdentifierString = "detailViewController"
        static let back = "Back"
        static let titleMoviesString = "Movies"
        static let topRatedString = "Top Rated"
        static let popularString = "Popular"
    }

    // MARK: - Public Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        let homeTable = app.tables[Constants.homeIdentifierString]
        homeTable.swipeUp()
        homeTable.swipeDown()
        homeTable.cells.firstMatch.tap()
        let movieButton = app.navigationBars[Constants.titleMoviesString].buttons[Constants.titleMoviesString]
        movieButton.tap()
        homeTable.swipeUp()
        homeTable.swipeUp()
        app.staticTexts[Constants.topRatedString].tap()
        homeTable.cells.firstMatch.tap()
        app.staticTexts[Constants.showTiser].tap()
        app.swipeUp()
        app.swipeDown()
        app.buttons[Constants.back].tap()
        app.swipeUp()
        app.swipeDown()
        app.buttons[Constants.topRatedString].tap()
        app.swipeUp()
        app.buttons[Constants.popularString].tap()
        app.swipeUp()
        app.swipeDown()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
