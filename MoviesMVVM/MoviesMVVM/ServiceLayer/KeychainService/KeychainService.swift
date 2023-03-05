// KeychainService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation
import KeychainSwift

/// Сервис  для хранения критических данных пользователя
struct KeychainService: KeychainServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Private Properties

    private let keyChain = KeychainSwift()
    private let apiKeyValue = Bundle.main.infoDictionary?[Url.apiKey] as? String

    // MARK: - Public Methods

    func setValue(_ value: String, forKey: String) {
        keyChain.set(value, forKey: forKey)
    }

    func getValue() -> String {
        guard let keyValue = keyChain.get(Url.apiKey) else { return String() }
        return keyValue
    }
}
