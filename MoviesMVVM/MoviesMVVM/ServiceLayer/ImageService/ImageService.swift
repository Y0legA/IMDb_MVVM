// ImageService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

// Сервис для получения фото
final class ImageService: ImageServiceProtocol {
    // MARK: - Private Properties

    private var imageProxyService: ImageProxyServiceProtocol

    // MARK: - Initializers

    init(imageProxyService: ImageProxyServiceProtocol) {
        self.imageProxyService = imageProxyService
    }

    // MARK: - Public Methods

    func fetchPhoto(byUrl url: String, completion: ((Data?) -> Void)?) {
        imageProxyService.fetchPhoto(byUrl: url, completion: completion)
    }
}
