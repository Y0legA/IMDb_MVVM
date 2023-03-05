// KeychainServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол сервиса хранения критических данных пользователя
protocol KeychainServiceProtocol {
    func setValue(_ value: String, forKey: String)
    func getValue() -> String
}
