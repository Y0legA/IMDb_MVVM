// ImageService.swift
// Copyright © Oleg Yakovlev All rights reserved.

import Foundation

/// Сервис для кеширования изображений
final class ImageService: ImageServiceProtocol {
    // MARK: Public Properties

    let imageApiService = ImageApiService()
    let fileManagerService = FileManagerService()

    // MARK: Public Method

    func getPhoto(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let proxy = Proxy(imageApiService: imageApiService, fileManagerService: fileManagerService)
        proxy.loadPhoto(url: url) { result in
            switch result {
            case let .success(image):
                completion(.success(image))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
