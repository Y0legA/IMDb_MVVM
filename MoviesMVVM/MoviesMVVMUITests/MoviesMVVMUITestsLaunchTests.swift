// MoviesMVVMTestsLaunchTests.swift
// Copyright © Oleg Yakovlev All rights reserved.

import XCTest

/// Tестирование загрузочного интерфейса
final class MoviesMVVMTestsLaunchTests: XCTestCase {
    // MARK: - Private Constants

    private enum Constants {
        static let launchScreen = "Launch Screen"
    }

    // MARK: - Public Methods

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = Constants.launchScreen
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
