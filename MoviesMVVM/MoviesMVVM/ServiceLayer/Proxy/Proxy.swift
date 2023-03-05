// Proxy.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Прокси сервис
final class Proxy: ProxyProtocol {
    // MARK: - Public Properties

    let imageApiService: ImageApiServiceProtocol
    let fileManagerService: FileManagerServiceProtocol

    // MARK: - Initializer

    init(imageApiService: ImageApiServiceProtocol, fileManagerService: FileManagerServiceProtocol) {
        self.imageApiService = imageApiService
        self.fileManagerService = fileManagerService
    }

    // MARK: - Public Methods

    func loadPhoto(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let image = fileManagerService.getImageFromCache(url: url) else {
            imageApiService.fetchImage(imageUrlPath: url) { [weak self] result in
                switch result {
                case let .success(data):
                    self?.fileManagerService.saveImageToCache(url: url, data: data)
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            return
        }
        completion(.success(image))
    }
}
