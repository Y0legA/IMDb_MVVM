// ImageServiceProtocol.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Протокол для сервиса получения изображений
protocol ImageServiceProtocol {
    func fetchPhoto(byUrl url: String, completion: ((Data?) -> Void)?)
}
