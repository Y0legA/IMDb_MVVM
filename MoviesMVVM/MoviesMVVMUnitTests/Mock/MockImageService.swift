// MockImageService.swift
// Copyright © Oleg Yakovlev. All rights reserved.

import Foundation

@testable import MoviesMVVM

/// Мок  сервиса получения изображений
final class MockImageService: ImageServiceProtocol {
    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> Void)?) {
        do {
            guard let data = url.data(using: .utf8) else { return }
            completion?(data)
        }
    }
}
