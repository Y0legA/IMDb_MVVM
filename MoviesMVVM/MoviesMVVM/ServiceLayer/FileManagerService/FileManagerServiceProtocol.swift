// FileManagerServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import UIKit

/// Протокол для файл-менеджера
protocol FileManagerServiceProtocol {
    func getImageFromCache(url: String) -> Data?
    func saveImageToCache(url: String, data: Data)
}
