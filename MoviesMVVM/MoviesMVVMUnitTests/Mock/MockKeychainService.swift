// MockKeychainService.swift
// Copyright © Oleg Yakovlev. All rights reserved.

import Foundation

@testable import MoviesMVVM

/// Мок кейчейн сервиса
final class MockKeychainService: KeychainServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let mockApiKeyString = "mockApiKey"
    }

    // MARK: - Public Properties

    var apiKeyValue: String?

    // MARK: - Public Methods

    func setValue(_ value: String, forKey _: String) {
        apiKeyValue = value
    }

    func getValue() -> String {
        Constants.mockApiKeyString
    }
}
